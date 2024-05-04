import 'dart:io';

import 'package:flutter/material.dart';
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
  String? objectName = '';
  int selectedTag = Get.find<SpaceController>().spaces[0].id; // 선택된 태그를 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDAF0FF),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
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
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                child: Text(
                  '이름을 등록해주세요',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF97ACB8),
                    fontSize: 20,
                    fontFamily: 'OHSQUARE',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.1,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFF8F7),
                    labelText: '이름',
                    hintText: '이름을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      objectName = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Text(
                  '내 장소에 등록해주세요!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF97ACB8),
                    fontSize: 20,
                    fontFamily: 'OHSQUARE',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.14,
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFF8F7),
                    labelText: '태그 선택',
                    labelStyle: TextStyle(
                      fontFamily: 'OHSQUARE',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  value: selectedTag,
                  items: Get.find<SpaceController>().spaces.map((space) {
                    return DropdownMenuItem<int>(
                      child: Text(space.spaceName),
                      value: space.id,
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedTag = newValue!;
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuInformationScreen(
                        image: widget.image,
                        name: objectName,
                        tag: selectedTag,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8, // 화면의 가로 90%에 해당하는 너비
                  decoration: ShapeDecoration(
                    color: Color(0xFF97ACB8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '다음으로',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFEFDF8),
                        fontSize: 18,
                        fontFamily: 'OHSQUARE',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
