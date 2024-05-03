
import 'package:camera_pj/controller/scan_controller.dart';
import 'package:camera_pj/screen/quiz_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loading_quiz_screen.dart';
import 'safty_information_screen.dart';

class AuInformationScreen extends StatefulWidget {
  const AuInformationScreen({super.key});

  @override
  State<AuInformationScreen> createState() => _AuInformationScreenState();
}

class _AuInformationScreenState extends State<AuInformationScreen> {
  final ScanController scanController = Get.find();
  Future<String> fetchData() {
    return Future.delayed(Duration(seconds: 60), () {
      print(11);
      return '데이터가 성공적으로 불러와졌습니다!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingQuizScreen();
            } else if (snapshot.hasError) {
              return Text('데이터를 불러오는 중에 오류가 발생했습니다.');
            } else {
              return SaftyInformationScreen();
            }
          },
        ),
      ),
    );
  }
}
