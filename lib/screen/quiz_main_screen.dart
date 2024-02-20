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
            return Column(
              children: [
                Text('현재 정어리 개수'),
                Container(
                  child: Row(
                    children: [
                      Image.asset('asset/img/fish.png'),
                      Text('${snapshot.data}'),
                    ],
                  ),
                ),
                Image.asset(
                    'asset/img/${snapshot.data! <= 10 ? 'small' : snapshot.data! <= 20 ? 'medium' : 'big'}_penguin.png'),
                Text('화재 안전 퀴즈 풀기'),
                ElevatedButton(
                  onPressed: () async {
                    await quizController.fetchQuizzes();
                    Get.to(() => QuizSolveScreen(index: 0));
                  },
                  child: Text('퀴즈 풀기 시작하기'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
