import 'package:camera_pj/component/button_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../controller/address_controller.dart';


class SaveMyPlaceScreen extends StatelessWidget {
  SaveMyPlaceScreen({Key? key}) : super(key: key);

  final AddressController addressController = Get.find<AddressController>();
  final TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        title: Text(
          '내장소 등록하기',
          style: TextStyle(fontFamily: 'OHSQUAREAIR'),
        ),
        backgroundColor: BACKGROUND_COLOR,
      ),
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      '장소 등록',
                      style: TextStyle(fontSize: 24, fontFamily: 'OHSQUARE',color: BUTTON_BLUE),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: BACKGROUND_SECOND_COLOR,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: TextField(
                      controller: nicknameController,
                      decoration: InputDecoration(
                        labelText: '내장소 이름 설정',
                        labelStyle: TextStyle(fontFamily: 'OHSQUAREAIR'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DefaultButton(buttonText: '장소 저장하기', onPressed: () {
                    String nickname = nicknameController.text;
                    if (nickname.isNotEmpty) {
                      addressController.savePlace(nickname);
                    } else {
                      Get.snackbar('Error', '이름을 입력해주세요');
                    }

                  }),
                  SizedBox(height: 20),
                  Text(
                    'Address: ${addressController.placeAddress}',
                    style: TextStyle(fontSize: 18,fontFamily: 'OHSQUAREAIR'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Latitude: ${addressController.latitude}',
                    style: TextStyle(fontSize: 18,fontFamily: 'OHSQUAREAIR'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Longitude: ${addressController.longitude}',
                    style: TextStyle(fontSize: 18,fontFamily: 'OHSQUAREAIR'),
                  ),


                ],
              ),
            ),
            Image.asset('asset/img/default_character_bottom.png'),

          ],
        ),
      )),
    );
  }
}
