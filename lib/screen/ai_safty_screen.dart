import 'package:camera_pj/controller/scan_controller.dart';
import 'package:camera_pj/screen/ai_safety_result.dart';
import 'package:camera_pj/screen/loading_quiz_screen.dart';
import 'package:camera_pj/screen/quiz_main_screen.dart';
import 'package:camera_pj/screen/safty_information_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

import '../component/token_manager.dart';
import '../controller/account_controller.dart';
import '../controller/quiz_controller.dart';

class AuInformationScreen extends StatefulWidget {
  final String? image;
  final String? name;
  final int? tag;
  const AuInformationScreen({
    required this.image,
    required this.name,
    required this.tag,
    Key? key,
  }) : super(key: key);
  @override
  State<AuInformationScreen> createState() => _AuInformationScreenState();
}

class _AuInformationScreenState extends State<AuInformationScreen> {
  final ScanController scanController = Get.find();
  late int tag2;
  Future<void> objectWithVisionPro(String file, String name, int tag) async {
    print(111);
    final dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: 30),
    ));

    var formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(file),
      'nickname': name,
      "my_space": tag,
    });

    final String? idToken = await TokenManager().getToken();

    try {
      dio.interceptors.add(CustomInterceptor());

      final response = await dio.post(
        'https://pengy.dev/api/gem-vision/generate-vision-result/',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        }),
        data: formData,
      );
      if (response.statusCode == 200) {
        print('11 사진 보내 버리기: ${response.data['space_detail_id']}');
        tag2 = response.data['space_detail_id'].toInt();
      } else {
        print('11 사진 못보내 버리기: ${response.data}');
      }
    } catch (e) {
      print('11 연결 안돼 버리기: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.find();

    return Scaffold(
      body: Center(
        child: FutureBuilder<void>(
          future: objectWithVisionPro(widget.image!, widget.name!, widget.tag!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터를 불러오는 중이고 quizPost가 true인 경우 LoadingQuizScreen을 표시
                return LoadingQuizScreen();
            } else if (snapshot.hasError) {
              return Text('데이터를 불러오는 중에 오류가 발생했습니다.');
            } else {
              print(tag2);
              print(widget.image);
              return AISafetyResultScreen(spaceId: tag2!, type: true, imgUrl: widget.image!);
            }
          },
        ),
      ),
    );
  }
}
