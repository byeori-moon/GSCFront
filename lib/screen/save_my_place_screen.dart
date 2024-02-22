import 'package:camera_pj/component/button_component.dart';
import 'package:camera_pj/controller/account_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../controller/address_controller.dart';

class SaveMyPlaceScreen extends StatelessWidget {
  SaveMyPlaceScreen({Key? key}) : super(key: key);

  final AddressController addressController = Get.find<AddressController>();
  final TextEditingController nicknameController = TextEditingController();
  String? selectedTag = 'Home'; // 선택된 태그를 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        title: Text(
          'Register My Location',
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
                      'Register Location',
                      style: TextStyle(fontSize: 24, fontFamily: 'OHSQUARE', color: BUTTON_BLUE),
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
                        labelText: 'Locatin name',
                        labelStyle: TextStyle(fontFamily: 'OHSQUAREAIR'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Tags',
                            labelStyle: TextStyle(fontFamily: 'OHSQUAREAIR'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          value: selectedTag,
                          items: ['Home', 'Cafe', 'Company'] // 선택할 태그 목록
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            // 선택된 태그 업데이트
                            selectedTag = newValue!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  DefaultButton(buttonText: 'Save Location', onPressed: () async {
                    String nickname = nicknameController.text;
                    String address= "${addressController.latitude.value}, ${addressController.longitude.value}";
                    String place = addressController.placeAddress.value;
                    if (nickname.isNotEmpty && selectedTag!.isNotEmpty) {
                      var tagIndex = 4;
                      if(selectedTag=='Cafe'){
                        tagIndex = 2;
                      }else if(selectedTag =='Company'){
                        tagIndex = 3;
                      }else if(selectedTag=='Home'){
                        tagIndex = 4;
                      }
                      addressController.savePlace(nickname, address, place,tagIndex);
                    } else {
                      Get.snackbar('Error', 'Please enter the name and tags.');
                    }
                  }),
                  SizedBox(height: 20),
                  Text(
                    'Address: ${addressController.placeAddress.value}',
                    style: TextStyle(fontSize: 18, fontFamily: 'OHSQUAREAIR'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Latitude: ${addressController.latitude.value}',
                    style: TextStyle(fontSize: 18, fontFamily: 'OHSQUAREAIR'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Longitude: ${addressController.longitude.value}',
                    style: TextStyle(fontSize: 18, fontFamily: 'OHSQUAREAIR'),
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
