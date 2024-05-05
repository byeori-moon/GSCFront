import 'package:camera_pj/component/button_component.dart';
import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/screen/ai_safety_result.dart';
import 'package:camera_pj/screen/information_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../component/temperature_component.dart';
import '../component/token_manager.dart';
import '../controller/space_controller.dart';
import '../controller/space_object_controller.dart';

class SpaceDetailScreen extends StatelessWidget {
  final Space space;

  SpaceDetailScreen({Key? key, required this.space}) : super(key: key);
  final SpaceObjectController spaceObjectController =
      Get.put(SpaceObjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        title: Text(space.spaceName),
        backgroundColor: BACKGROUND_COLOR,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 40),
        child: FutureBuilder<List<SpaceDetail>>(
            future: spaceObjectController.fetchSpaceObjects(space.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              print(spaceObjectController.spaceDetails.length.toString());
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: SizedBox()),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                child: Image.asset(
                                  'asset/img/thermometer.gif',
                                ),
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${space.average_temperature}`C',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 8 / 9,
                      ),
                      itemCount: spaceObjectController.spaceDetails.length,
                      itemBuilder: (context, index) {
                        SpaceDetail spaceDetail =
                            spaceObjectController.spaceDetails[index];
                        print(spaceDetail.id);
                        print(spaceDetail.thumbnailImage);
                        print(spaceDetail.mySpace);
                        print(spaceDetail.nickname);
                        return GestureDetector(
                          onTap: () {
                            // 클릭 이벤트 처리
                            // 예: 상세 페이지로 이동
                            // Get.to(() => InformationScreen(objectId: '${spaceDetail.fireHazard}',type: false));
                            showDetailModal(context, spaceDetail.id,
                                spaceDetail.thumbnailImage);
                          },
                          child: Card(
                            color: DEFAULT_YELLOW,
                            margin: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8), // 이미지 모서리를 둥글게 처리
                                  child: AspectRatio(
                                    aspectRatio: 1, // 정사각형 비율 유지
                                    child: Image.network(
                                      spaceDetail.thumbnailImage,
                                      fit: BoxFit.cover, // 이미지가 컨테이너 크기에 맞게 조정
                                    ),
                                  ),
                                ),
                                Text(spaceDetail.nickname),
                              ],
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                    ),
                  ),
                  DefaultButton(
                      buttonText: 'Advice',
                      onPressed: () async {
                        Future<String> fetchAdvice(int spaceId) async {
                          final Dio dio = Dio();
                          final idToken = await TokenManager().getToken();
                          final response = await dio.get(
                            'https://pengy.dev/api/spaces/advice/$spaceId/',
                            options: Options(headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $idToken',
                            }),
                          );
                          print(1);
                          if (response.statusCode == 200 ||
                              response.statusCode == 404) {
                            final jsonResponse = response.data;
                            print(response.data);
                            return jsonResponse['fire_prevention_tips'];
                          } else {
                            print(response.statusCode);
                            throw Exception('Failed to load advice');
                          }
                        }

                        try {
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: FutureBuilder<String>(
                                    future: fetchAdvice(space.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData) {
                                        return Text('No data available');
                                      }
                                      return Text(
                                        snapshot.data!,
                                        overflow: TextOverflow.visible,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('조언을 가져오는데 실패했습니다: $e')),
                          );
                        }
                      })
                ],
              );
            }),
      ),
    );
  }
}

void showDetailModal(BuildContext context, int id, String imgUrl) {
  final SpaceObjectController spaceObjectController = Get.find();

  showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return FutureBuilder<List<UserFireHazard>>(
          future: spaceObjectController.fetchFireHazardDetails(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 330,
                  child: Material(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 45),
                      child: Column(
                        children: [
                          Row(children: [
                            Icon(Icons.checklist_rtl,size: 30,color: BUTTON_BLUE,),
                            Text('CHECK LIST',style: TextStyle(
                              fontFamily: 'OHSQUARE',
                              fontSize: 30,
                              color: BUTTON_BLUE
                            ),),
                          ],),
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                UserFireHazard hazard = snapshot.data![index];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${hazard.fireHazard.object}",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(999),
                                              color: hazard.isChecked? BUTTON_BLUE:Colors.white,
                                              border: Border.all(
                                                color: BUTTON_BLUE, // 테두리 색상
                                                width: 1.0, // 테두리 두께
                                              ),
                                            ),
                                            child: Icon(Icons.check,size: 18,color: hazard.isChecked? Colors.white:BUTTON_BLUE,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        SizedBox(
                                          height: 45,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: BUTTON_BLUE,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(999),
                                                  side: BorderSide(
                                                    color: BUTTON_BLUE,
                                                    width: 1,
                                                  )),
                                            ),
                                            onPressed: () async {
                                              final dio = Dio()
                                                ..options.followRedirects = true
                                                ..options.maxRedirects = 5;
                                              final String baseUrl = "http://pengy.dev";

                                              try {
                                                final idToken = await TokenManager().getToken();
                                                if (idToken != null) {
                                                  final response = await dio.post(
                                                    '$baseUrl/api/fire-hazards/update-check',
                                                    options: Options(
                                                      headers: {
                                                        'Content-Type': 'application/json',
                                                        'Authorization': 'Bearer $idToken',
                                                      },
                                                    ),
                                                    data: {
                                                      'id': hazard.fireHazard.id,
                                                    },
                                                  );

                                                  if (response.statusCode == 200) {
                                                    print('화재 위험 체크 상태 업데이트 성공: ${response.data}');

                                                  } else {
                                                    print('화재 위험 체크 상태 업데이트 실패: ${response.data}');
                                                  }

                                                } else {
                                                  print('인증 토큰 없음');
                                                }
                                              } catch (e) {
                                                print('화재 위험 체크 상태 업데이트 중 오류 발생: $e');
                                              }
                                              Get.to(() => InformationScreen(
                                                objectId:
                                                '${hazard.fireHazard.id}',
                                                type: false,
                                              ));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.add),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '화재 관련 정보 보기',
                                                  style: TextStyle(
                                                    fontFamily: 'OHSQUARE',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Divider(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 240,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: BUTTON_BLUE,
                                  foregroundColor: BUTTON_WHITE,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Go to AI Safety Result',
                                    style: TextStyle(
                                      fontFamily: 'OHSQUARE',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {

                                Get.to(() => AISafetyResultScreen(
                                    spaceId: id, type: false, imgUrl: imgUrl));                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Text("No data available");
            }
          },
        );
      });
}
