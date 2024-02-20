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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 140,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            '${quizController.quizzes[index].question}',
                            style: TextStyle(
                                fontFamily: 'DONGDONG',
                                color: BACKGROUND_COLOR,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      Image.asset(
                          'asset/img/${quizController.score! <= 10 ? 'small' : quizController.score! <= 20 ? 'medium' : 'big'}_penguin_quiz.png'),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
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
                                  backgroundColor:
                                      quizController.quizAnswer == true
                                          ? BUTTON_PINK
                                          : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0),
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
                                    fontSize: 110,
                                    color: quizController.quizAnswer == true
                                        ? Colors.white
                                        : BUTTON_PINK,
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
                                    borderRadius: BorderRadius.circular(
                                        20.0), // 둥근 모서리 설정
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
                                    fontSize: 110,
                                    color: quizController.quizAnswer == false
                                        ? Colors.white
                                        : BUTTON_PINK,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '현재 점수: ${quizController.quizScore}/5',
                            style: TextStyle(
                              color: BACKGROUND_COLOR,
                              fontFamily: 'OHSQUARE',
                              fontSize: 20,
                            ),
                          ),
                          ElevatedButton(

                            onPressed: quizController.quizAnswer == null
                                ? null
                                : () {
                                    index += 1;
                                    quizController.updateScreen(index - 1);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: BUTTON_BLUE,
                              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 40)
                            ),
                            child: Text(
                              '다음 문제',
                              style: TextStyle(
                                fontFamily: 'OHSQUARE',
                                fontSize: 18,
                              ),
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
