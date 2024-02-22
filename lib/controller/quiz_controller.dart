import 'package:camera_pj/screen/home_screen.dart';
import 'package:camera_pj/screen/quiz_main_screen.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../component/token_manager.dart';
import 'account_controller.dart';

class Quiz {
  final String question;
  final bool answer;

  Quiz({required this.question, required this.answer});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class QuizController extends GetxController {
  List<Quiz> quizzes = [];
  late int score;
  bool? quizAnswer;
  int quizScore = 0;

  @override
  void onInit() {
    super.onInit();
  }

  void updateQuizAnswer(bool selectQuizAnswer) {
    quizAnswer = selectQuizAnswer;
    update();
  }

  void updateScreen(int index) async {
    if (index == 4) {
      await postQuizScore(quizScore).then((value) => Get.offAll(HomeScreen(initialIndex: 2,), transition: Transition.fade));
      quizAnswer=null;
      quizScore = 0;
    } else {
      if (quizzes[index].answer == quizAnswer) {
        quizScore += 1;
      }
      quizAnswer = null;
      update();
    }
  }

  Future<int> fetchScore() async {
    final dio = Dio();

    try {
      final idToken = await TokenManager().getToken();
      if (idToken != null) {
        final response = await dio.get(
          'https://pengy.dev/api/quizzes/get-score/',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
          ),
        );
        if (response.statusCode == 200) {
          score = response.data['fish_score'];
        }
      }
    } catch (e) {
      print(e);
    }
    return score;
  }

  Future<List<Quiz>> fetchQuizzes() async {
    final dio = Dio();

    try {
      final idToken = await TokenManager().getToken();
      if (idToken != null) {
        final response = await dio.get(
          'https://pengy.dev/api/quizzes/get-quiz/',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
          ),
        );
        if (response.statusCode == 200) {
          List<Quiz> fetchedQuizzes = (response.data['quizzes'] as List)
              .map((quizJson) => Quiz.fromJson(quizJson))
              .toList();
          quizzes = fetchedQuizzes;
        }
      }
      return quizzes;
    } catch (e) {
      print(e);
    }
    return quizzes;
  }

  Future<void> postQuizScore(int score) async {
    final dio = Dio();

    try {
      dio.interceptors.add(CustomInterceptor());

      final idToken = await TokenManager().getToken();
      if (idToken != null) {
        final response =
            await dio.post('https://pengy.dev/api/quizzes/update-score/',
                options: Options(
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $idToken',
                  },
                ),
                data: {'correct_answers_count': score});
        if (response.statusCode == 200) {
          print(response.data);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
