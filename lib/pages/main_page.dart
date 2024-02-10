import 'package:camera_pj/component/input_component.dart';
import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/pages/camera.dart';
import 'package:camera_pj/pages/map_page.dart';
import 'package:camera_pj/screen/search_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "새롭게 내 장소를 등록해주세요!",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: BUTTON_BLUE,
                fontFamily: 'OHSQUARE',
                fontSize: 20,
              ),
            ),
            GestureDetector(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: BACKGROUND_SECOND_COLOR,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "지번, 도로명, 건물명으로 검색",
                    style: TextStyle(
                      color: BUTTON_BLUE,
                      fontFamily: 'OHSQUAREAIR',
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              onTap: () {
                Get.to(SearchPlaceScreen());
              },
            ),
            Text(
              "지도에서 장소 확인하기",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: BUTTON_BLUE,
                fontFamily: 'OHSQUARE',
                fontSize: 20,
              ),
            ),
            Container(
              height: 95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(CameraApp());
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: SHADOW_BLUE,
                        onPrimary: Colors.black.withOpacity(0.8),
                        primary: MAINSCREEN_COLOR,
                        elevation: 3,
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // 원하는 radius 값으로 변경
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/img/camera_penguin.png',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(width: 14,),
                          Text(
                            '빠른 촬영',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OHSQUAREAIR',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(CameraApp());
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: SHADOW_BLUE,
                        onPrimary: Colors.black.withOpacity(0.8),
                        primary: MAINSCREEN_COLOR,
                        elevation: 3,
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0), // 원하는 radius 값으로 변경
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/img/flag_penguin.png',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(width: 14,),
                          Text(
                            '내 장소\n리스트',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OHSQUAREAIR',
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    } else if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied forever");
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      throw Exception("Error getting current location: $e");
    }
  }
}
