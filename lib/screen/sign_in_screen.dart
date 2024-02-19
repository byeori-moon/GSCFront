import 'package:camera_pj/component/input_component.dart';
import 'package:camera_pj/constant/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/button_component.dart';
import '../component/sign_in_component.dart';
import '../controller/account_controller.dart';

class SignInNameInput extends StatefulWidget {
  const SignInNameInput({Key? key});

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
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: '이름',
                      labelStyle: TextStyle(fontFamily: 'OHSQUAREAIR'),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SecondButton(buttonText: '이전', onPressed: () {}),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: DefaultButton(
                      buttonText: '다음으로',
                      onPressed: () async {
                        print("ct: ${_controller.text}");
                        // 여기서 _controller.text를 사용합니다.
                        accountController.signUpWithGoogle(_controller.text);
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
