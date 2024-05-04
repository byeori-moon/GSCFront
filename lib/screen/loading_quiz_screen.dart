import 'package:camera_pj/screen/quiz_solve_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/quiz_controller.dart';

class LoadingQuizScreen extends StatefulWidget {
  const LoadingQuizScreen({super.key});

  @override
  State<LoadingQuizScreen> createState() => _LoadingQuizScreenState();
}

class _LoadingQuizScreenState extends State<LoadingQuizScreen> {
  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.find();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF678DAD),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Waiting for the AI result...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Cafe24 Ohsquare',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              SizedBox(
                child: Image.asset(
                  'asset/img/medium_penguin.png', // 이미지 파일 경로
                  width: MediaQuery.of(context).size.width * 0.5, // 화면의 가로 90%에 해당하는 너비
                  fit: BoxFit.contain, // 이미지를 적절히 화면에 맞게 조절
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Text(
                '기다리는동안 퀴즈푸실?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFEFDF8),
                  fontSize: 28,
                  fontFamily: 'Cafe24 Ohsquare OTF',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // 클릭 이벤트 처리
                      // 여기에 클릭 이벤트에 대한 동작을 추가하세요
                      print(11);
                      await quizController.fetchQuizzes();
                      quizController.updateQuizPost(false);
                      quizController.quizAnswer=null;
                      quizController.quizScore=0;
                      Get.to(() => QuizSolveScreen(index: 0));
                    },
                    child: Container(
                      width: 176,
                      height: 54,
                      padding: const EdgeInsets.only(left: 29, right: 31),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFEFDF8),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFF97ACB8)),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'START',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF97ACB8),
                              fontSize: 15,
                              fontFamily: 'Cafe24 Ohsquare OTF',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
