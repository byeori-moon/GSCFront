import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/screen/quiz_solve_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/quiz_controller.dart';

class QuizMainScreen extends StatelessWidget {
  QuizMainScreen({super.key});

  final QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FIRSTSCREEN_COLOR,
      body: Center(
        child: FutureBuilder<int>(
          future: quizController.fetchScore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 40, bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Caught fish',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'OHSQUARE',
                            color: BACKGROUND_COLOR,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: SizedBox()),
                          Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Image.asset('asset/img/fish.png'),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'OHSQUARE',
                                    color: BACKGROUND_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                          'asset/img/${snapshot.data! <= 10 ? 'small' : snapshot.data! <= 20 ? 'medium' : 'big'}_penguin.png',fit: BoxFit.contain,),
                      Text(
                        'Fire Safety Quiz',
                        style: TextStyle(
                          fontFamily: 'OHSQUARE',
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(child: SizedBox(),),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: BUTTON_BLUE,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            await quizController.fetchQuizzes();
                            quizController.quizAnswer=null;
                            quizController.quizScore=0;
                            Get.to(() => QuizSolveScreen(index: 0));
                          },
                          child: Text('Start the Quiz',style: TextStyle(fontFamily: 'OHSQUARE'),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
