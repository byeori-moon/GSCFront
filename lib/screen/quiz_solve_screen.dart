import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/screen/quiz_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/quiz_controller.dart';

class QuizSolveScreen extends StatelessWidget {
  QuizSolveScreen({Key? key, required this.index}) : super(key: key);
  int index;

  final QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
        init: quizController,
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              backgroundColor: FIRSTSCREEN_COLOR,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          '${quizController.quizzes[index].question}',
                        ),
                      ),
                      Image.asset(
                          'asset/img/${quizController.score! <= 10 ? 'small' : quizController.score! <= 20 ? 'medium' : 'big'}_penguin_quiz.png'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: BUTTON_PINK,
                                offset: Offset(0, 0),
                                blurRadius: 20,
                                spreadRadius: 1,
                              )
                            ]),
                            child: OutlinedButton(
                              onPressed: () {
                                quizController.updateQuizAnswer(true);
                                print(quizController.quizAnswer);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: BUTTON_PINK,
                                backgroundColor: quizController.quizAnswer == true
                                    ? BUTTON_PINK
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20.0), // 둥근 모서리 설정
                                ),
                                side: BorderSide(
                                  color: BUTTON_PINK,
                                  width: 3,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                              ),
                              child: Text(
                                'O',
                                style: TextStyle(
                                  fontFamily: "OHSQUARE",
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: BUTTON_PINK,
                                offset: Offset(0, 0),
                                blurRadius: 20,
                                spreadRadius: 1,
                              )
                            ]),
                            child: OutlinedButton(
                              onPressed: () {
                                quizController.updateQuizAnswer(false);
                                print(quizController.quizAnswer);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: BUTTON_PINK,
                                backgroundColor:
                                    quizController.quizAnswer == false
                                        ? BUTTON_PINK
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20.0), // 둥근 모서리 설정
                                ),
                                side: BorderSide(
                                  color: BUTTON_PINK,
                                  width: 3,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                              ),
                              child: Text(
                                'X',
                                style: TextStyle(
                                  fontFamily: "OHSQUARE",
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('현재 점수: ${quizController.quizScore}'),
                          ElevatedButton(
                            onPressed: quizController.quizAnswer == null
                                ? null
                                : () {
                                    index += 1;
                                    quizController.updateScreen(index - 1);
                                  },
                            child: Text(
                              '다음 문제',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
