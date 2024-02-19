import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/constant/enums.dart';
import 'package:camera_pj/screen/map_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../component/token_manager.dart';
import '../screen/space_detail_screen.dart';

class Space {
  final int id;
  final int firebaseUID;
  final SpaceCategoryType category;
  final String spaceName;
  final String coordinates;
  final String address;

  Space({
    required this.id,
    required this.firebaseUID,
    required this.category,
    required this.spaceName,
    required this.coordinates,
    required this.address,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    SpaceCategoryType spaceCategoryType;
    switch (json['category']) {
      case "집":
        spaceCategoryType = SpaceCategoryType.house;
        break;
      case "직장":
        spaceCategoryType = SpaceCategoryType.office;
        break;
      case "카페":
        spaceCategoryType = SpaceCategoryType.cafe;
        break;
      default:
        spaceCategoryType = SpaceCategoryType.etc;
        break;
    }
    return Space(
      id: json['id'],
      firebaseUID: json['FirebaseUID'],
      category: spaceCategoryType,
      spaceName: json['spaceName'],
      coordinates: json['coordinates'],
      address: json['address'],
    );
  }
}

class SpaceController extends GetxController {
  var currentCategory = SpaceCategoryType.all.obs;
  var spaces = <Space>[].obs;

  List<List<dynamic>> extractTagsAndIds(List<Space> spaces) {
    List<List<dynamic>> tagsAndIds = [];
    for (Space space in spaces) {
      // Space 객체에서 tag와 id 추출하여 배열에 추가
      String tag = space.spaceName;
      int id = space.id;
      tagsAndIds.add([tag, id]);
    }
    return tagsAndIds;
  }

  Future<List<Space>> fetchMySpaces() async {
    var dio = Dio();
    final idToken = await TokenManager().getToken();
    final response = await dio.get(
      'https://pengy.dev/api/spaces/myspace/',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> spacesJson = response.data;
      var fetchedSpaces =
          spacesJson.map((json) => Space.fromJson(json)).toList();
      spaces.assignAll(fetchedSpaces);
      print("spc: ${spaces[0].id}");
      return spacesJson.map((json) => Space.fromJson(json)).toList();
    } else {
      print("error");
      throw Exception('Failed to load my spaces');
    }
  }

  Set<Marker> getMarkers(BuildContext context) {
    fetchMySpaces();
    return spaces.map((space) {
      var coords = space.coordinates.split(', ').map(double.parse).toList();
      return Marker(
        markerId: MarkerId('${space.id}'),
        position: LatLng(coords[0], coords[1]),
        infoWindow: InfoWindow(
          title: space.spaceName,
          snippet: space.category == SpaceCategoryType.house
              ? '집'
              : space.category == SpaceCategoryType.office
                  ? '직장'
                  : space.category == SpaceCategoryType.cafe
                      ? '카페'
                      : '기타',
        ),
        onTap: () {
          _showModalBottomSheet(context, space);
        },
      );
    }).toSet();
  }

  void _showModalBottomSheet(BuildContext context, Space space) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SpaceCategoryIcon(
                      spaceCategoryType: space.category,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Text(
                          space.spaceName,
                          style: TextStyle(
                            fontFamily: 'OHSQUARE',
                            fontSize: 25,
                            color: Color(0XFF272727),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          space.address,
                          style: TextStyle(
                            fontFamily: 'OHSQUAREAIR',
                            fontSize: 16,
                            color: Color(0XFF727272),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(),
              ),
              SizedBox(
                height: 50,
                width: 160,
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
                        Icons.add,
                        size: 20,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '장소 상세보기',
                        style: TextStyle(
                          fontFamily: 'OHSQUARE',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Get.to(() => SpaceDetailScreen(space: space));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showMySpacesModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 1000,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: FutureBuilder<List<Space>>(
              future: fetchMySpaces(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }else if (!snapshot.hasData) {
                  return Text('No data available');
                }
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Divider(
                          thickness: 3,
                          indent: 120,
                          endIndent: 120,
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25.0, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: SpaceCategoryType.values.map((category) {
                              return SizedBox(
                                height: 30,
                                width: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: BUTTON_BLUE,
                                    padding: EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: BUTTON_BLUE,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    currentCategory.value = category;
                                  },
                                  child: Text(
                                    category == SpaceCategoryType.house
                                        ? '집'
                                        : category == SpaceCategoryType.office
                                            ? '직장'
                                            : category == SpaceCategoryType.cafe
                                                ? '카페'
                                                : category ==
                                                        SpaceCategoryType.etc
                                                    ? '기타'
                                                    : '전체',
                                    style: TextStyle(
                                      fontFamily: 'OHSQUARE',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(child: Obx(() {
                          var filteredSpaces = currentCategory.value ==
                                  SpaceCategoryType.all
                              ? spaces
                              : spaces
                                  .where((space) =>
                                      space.category == currentCategory.value)
                                  .toList();

                          return ListView.builder(
                            itemCount: filteredSpaces.length,
                            itemBuilder: (context, index) {
                              Space space = filteredSpaces[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => SpaceDetailScreen(space: space));
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SpaceCategoryIcon(
                                              spaceCategoryType: space.category,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  space.spaceName,
                                                  style: TextStyle(
                                                    fontFamily: 'OHSQUARE',
                                                    fontSize: 25,
                                                    color: Color(0XFF272727),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                  space.address,
                                                  style: TextStyle(
                                                    fontFamily: 'OHSQUAREAIR',
                                                    fontSize: 16,
                                                    color: Color(0XFF727272),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Divider(),
                                      ),
                                    ]),
                              );
                            },
                          );
                        }))
                      ],
                    ),
                    Positioned(
                      bottom: 22,
                      child: SizedBox(
                        height: 50,
                        width: 130,
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
                                Icons.room,
                                size: 20,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '지도보기',
                                style: TextStyle(
                                  fontFamily: 'OHSQUARE',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Get.to(() => MapScreen());
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }
}

class SpaceCategoryIcon extends StatelessWidget {
  const SpaceCategoryIcon({super.key, required this.spaceCategoryType});

  final SpaceCategoryType spaceCategoryType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(right: 5, left: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: BUTTON_BLUE,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            spaceCategoryType == SpaceCategoryType.house
                ? Icons.house_outlined
                : spaceCategoryType == SpaceCategoryType.office
                    ? Icons.apartment
                    : spaceCategoryType == SpaceCategoryType.cafe
                        ? Icons.local_cafe
                        : Icons.more,
            size: 30,
            color: BUTTON_BLUE,
          ),
        ),
        Text(
          spaceCategoryType == SpaceCategoryType.house
              ? '집'
              : spaceCategoryType == SpaceCategoryType.office
                  ? '직장'
                  : spaceCategoryType == SpaceCategoryType.cafe
                      ? '카페'
                      : '기타',
          style: TextStyle(
            fontFamily: 'OHSQUAREAIR',
            fontSize: 15,
            color: BUTTON_BLUE,
          ),
        ),
      ],
    );
  }
}
