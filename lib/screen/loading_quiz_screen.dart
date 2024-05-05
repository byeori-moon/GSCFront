import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../controller/quiz_controller.dart';

class LoadingQuizScreen extends StatefulWidget {
  const LoadingQuizScreen({super.key});

  @override
  State<LoadingQuizScreen> createState() => _LoadingQuizScreenState();
}

class _LoadingQuizScreenState extends State<LoadingQuizScreen> {
  bool isButtonClicked = true;
  final QuizController quizController = Get.find();
  bool _isTextVisible = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    initializeQuizController();
    startBlinking();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void initializeQuizController() async {
    await quizController.fetchQuizzes();
    quizController.updateQuizPost(false);
    quizController.quizAnswer = null;
    quizController.quizScore = 0;
  }

  void startBlinking() {
    _timer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      setState(() {
        _isTextVisible = !_isTextVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF678DAD),
        body: isButtonClicked
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                duration: Duration(milliseconds: 700),
                opacity: 1.0,
                curve: Curves.easeInOut,
                child: Text(
                  'Generating...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'OHSQUARE',
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 1500),
                opacity: _isTextVisible ? 1.0 : 0.0,
                curve: Curves.easeInOut,
                child: Image.asset(
                  'asset/img/medium_penguin.png', // 이미지 파일 경로
                  width: MediaQuery.of(context).size.width * 0.6, // 화면의 가로 90%에 해당하는 너비
                  fit: BoxFit.contain, // 이미지를 적절히 화면에 맞게 조절
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                'Quiz About Fire Safty',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFEFDF8),
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'OHSQUARE',
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
                      setState(() {
                        isButtonClicked = !isButtonClicked;
                      });
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
        )
            : QuizSolvingScreen(index: 0),
      ),
    );
  }
}
class QuizSolvingScreen extends StatefulWidget {
  QuizSolvingScreen({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  _QuizSolvingScreenState createState() => _QuizSolvingScreenState();
}

class _QuizSolvingScreenState extends State<QuizSolvingScreen> {
  bool _isTextVisible = true;
  late Timer _timer;
  int index = 0;
  @override
  void initState() {
    super.initState();
    startBlinking();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void startBlinking() {
    _timer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      setState(() {
        _isTextVisible = !_isTextVisible;
      });
    });
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 700),
                      opacity: 1.0 ,
                      curve: Curves.easeInOut,
                      child: Text(
                        'Generating...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'OHSQUARE',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 1500),
                      opacity: _isTextVisible ? 1.0 : 0.0,
                      curve: Curves.easeInOut,
                    child: Image.asset(
                      'asset/img/${quizController.score! <= 10 ? 'small' : quizController.score! <= 20 ? 'medium' : 'big'}_penguin.png',
                    ),
                    ),
                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          '${quizController.quizzes[widget.index].question}',
                          style: TextStyle(
                            fontFamily: 'DONGDONG',
                            color: BACKGROUND_COLOR,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: BUTTON_PINK,
                                  offset: Offset(0, 0),
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                quizController.updateQuizAnswer(true);
                                print(quizController.quizAnswer);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: BUTTON_PINK,
                                backgroundColor:
                                quizController.quizAnswer == true ? BUTTON_PINK : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
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
                                  color: quizController.quizAnswer == true ? Colors.white : BUTTON_PINK,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: BUTTON_PINK,
                                  offset: Offset(0, 0),
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                quizController.updateQuizAnswer(false);
                                print(quizController.quizAnswer);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: BUTTON_PINK,
                                backgroundColor:
                                quizController.quizAnswer == false ? BUTTON_PINK : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
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
                                  color: quizController.quizAnswer == false ? Colors.white : BUTTON_PINK,
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
                        Container(),
                        ElevatedButton(
                          onPressed: quizController.quizAnswer == null
                              ? null
                              : () {
                            index += 1; // widget.index 변경
                            quizController.updateScreen(index - 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: BUTTON_BLUE,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                          ),
                          child: Text(
                            'Next',
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
      },
    );
  }
}
