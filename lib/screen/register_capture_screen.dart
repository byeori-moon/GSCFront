import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controller/space_controller.dart';
import 'ai_safty_screen.dart';

class RegisterCaptureScreen extends StatefulWidget {
  final String image; // XFile을 nullable로 변경
  const RegisterCaptureScreen({required this.image, Key? key}) : super(key: key);

  @override
  State<RegisterCaptureScreen> createState() => _RegisterCaptureScreenState();
}

class _RegisterCaptureScreenState extends State<RegisterCaptureScreen> {
  @override
  Widget build(BuildContext context) {
    String? objectName = '';
    final spaceController = Get.find<SpaceController>(); // 가정한 ScanController 가져오기
    int selectedTag = spaceController.spaces[0].id; // 선택된 태그를 저장하는 변수
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xFFDAF0FF),
          body: Center(
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width *0.6,
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // border 색상 설정
                      width: 3.0, // border 두께 설정
                    ),
                    borderRadius: BorderRadius.circular(10.0), // 모든 모서리를 뭉뚝하게 만듭니다.

                  ),
                  child: Image.file(
                    File(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width *0.8,
                  height: MediaQuery.of(context).size.height * 0.8*0.08,
                  child: Text(
                    '이름을 등록해주세요',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFF97ACB8),
                      fontSize: 20,
                      fontFamily: 'Cafe24 Ohsquare OTF',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width *0.8,
                  height: MediaQuery.of(context).size.height * 0.8*0.1,
                  child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFFFF8F7),
                        labelText: '이름',
                        hintText: '이름을 입력하세요',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        objectName = value;
                      },
                    ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width *0.8,
                  height: MediaQuery.of(context).size.height * 0.8*0.1,
                  child: Text(
                    '내 장소에 등록해주세요!',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFF97ACB8),
                      fontSize: 20,
                      fontFamily: 'Cafe24 Ohsquare OTF',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width *0.8,
                  height: MediaQuery.of(context).size.height * 0.8*0.14,
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFFF8F7),
                      labelText: '태그 선택',
                      labelStyle: TextStyle(fontFamily: 'OHSQUAREAIR'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    value: selectedTag,
                    items: spaceController.spaces.map((space) {
                      return DropdownMenuItem<int>(
                        child: Text(space.spaceName),
                        value: space.id,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      // 선택된 태그 업데이트
                      selectedTag = newValue!;
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        AuInformationScreen(image: widget.image, name: objectName, tag: selectedTag)
                    ));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8 * 0.1,
                    width: MediaQuery.of(context).size.width * 0.8, // 화면의 가로 90%에 해당하는 너비
                    decoration: ShapeDecoration(
                      color: Color(0xFF97ACB8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '다음으로',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFEFDF8),
                            fontSize: 18,
                            fontFamily: 'BM JUA_OTF',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

          ),
        ),
    );
  }
}
