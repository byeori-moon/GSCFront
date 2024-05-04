import 'package:camera_pj/component/input_component.dart';
import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/screen/home_screen.dart';
import 'package:camera_pj/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/button_component.dart';
import '../component/sign_in_component.dart';
import '../controller/account_controller.dart';

class SignInNameInput extends StatefulWidget {
  const SignInNameInput({super.key});

  @override
  State<SignInNameInput> createState() => _SignInNameInputState();
}

class _SignInNameInputState extends State<SignInNameInput> {
  final TextEditingController _controller = TextEditingController();
  final AccountController accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset('asset/img/default_character_nobg.png'),
                  Text(
                    '이름을 입력해주세요!',
                    style: TextStyle(
                      fontFamily: 'OHSQUARE',
                      color: BUTTON_BLUE,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InputComponent(hintText: '이름', onSubmitted: (value) { _controller.text=value;}),
                ],
              ),
              Row(
                children: [
                  SecondButton(buttonText: '이전', onPressed: () {
                    Get.to(LoginScreen());
                  }),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: DefaultButton(
                      buttonText: '회원가입 완료',
                      onPressed: () async {
                        accountController.signUpWithGoogle(_controller.text).then((value) => Get.to(HomeScreen()));
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
