import 'package:camera_pj/component/button_component.dart';
import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/screen/information_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 8 / 9,
                      ),
                      itemCount: spaceObjectController.spaceDetails.length,
                      itemBuilder: (context, index) {
                        SpaceDetail spaceDetail = spaceObjectController.spaceDetails[index];
                        return GestureDetector(
                          onTap: () {
                            // 클릭 이벤트 처리
                            // 예: 상세 페이지로 이동
                            Get.to(() => InformationScreen(objectId: '${spaceDetail.fireHazard}',type: false));
                          },
                          child: Card(
                            color: DEFAULT_YELLOW,
                            margin: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  spaceDetail.thumbnailImage,
                                  fit: BoxFit.contain,
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
                          if (response.statusCode == 200) {
                            final jsonResponse = response.data;
                            print(response.data);
                            return jsonResponse['fire_prevention_tips'];
                          } else {
                            throw Exception('Failed to load advice');
                          }
                        }

                        try {
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext context) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              return Expanded(
                                child: FutureBuilder<String>(
                                    future: fetchAdvice(
                                        space.id),
                                    builder: (context,snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      }else if (!snapshot.hasData) {
                                        return Text('No data available');
                                      }
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Text(snapshot.data!,
                                              overflow: TextOverflow.visible),
                                        ),
                                      );
                                    }
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