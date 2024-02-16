import 'package:camera_pj/component/input_component.dart';
import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/controller/account_controller.dart';
import 'package:camera_pj/pages/camera.dart';
import 'package:camera_pj/screen/map_screen.dart';
import 'package:camera_pj/screen/search_place_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../component/sign_in_component.dart';
import '../controller/space_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SpaceController spaceController = Get.find();
    final AccountController accountController = Get.find();

    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 70),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: GestureDetector(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "지도에서 장소 확인하기",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: BUTTON_BLUE,
                  fontFamily: 'OHSQUARE',
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: DEFAULT_YELLOW,
                      width: 6,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const MapScreen()),
                    ),
                    child: MapScreen(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          getInformation();
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: SHADOW_BLUE,
                          foregroundColor: Colors.black.withOpacity(0.8),
                          backgroundColor: MAINSCREEN_COLOR,
                          elevation: 3,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
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
                            SizedBox(
                              width: 14,
                            ),
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
                          spaceController.showMySpacesModal(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: SHADOW_BLUE,
                          foregroundColor: Colors.black.withOpacity(0.8),
                          backgroundColor: MAINSCREEN_COLOR,
                          elevation: 3,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
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
                            SizedBox(
                              width: 14,
                            ),
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
