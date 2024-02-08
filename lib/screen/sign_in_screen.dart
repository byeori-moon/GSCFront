import 'package:camera_pj/component/input_component.dart';
import 'package:camera_pj/constant/colors.dart';
import 'package:flutter/material.dart';

import '../component/button_component.dart';

class SignInNameInput extends StatefulWidget {
  const SignInNameInput({super.key});

  @override
  State<SignInNameInput> createState() => _SignInNameInputState();
}

class _SignInNameInputState extends State<SignInNameInput> {
  final TextEditingController _controller = TextEditingController();

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
                  InputComponent(hintText: '이름', onSubmitted: (value) {}),
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
                      onPressed: () {},
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
