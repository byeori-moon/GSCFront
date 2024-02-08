import 'package:camera_pj/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../component/sign_in_component.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Image.asset('asset/img/default_character_main.png',fit: BoxFit.contain,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GoogleButton(
                      name: '구글 계정으로 로그인하기',
                      onPressed: () {
                        signInWithGoogle().then((user) {
                          if (user != null) {
                            print("로그인 성공: ${user.displayName}");
                          }
                        });
                      },
                    ),
                    _GoogleButton(
                      name: '구글 계정으로 회원가입하기',
                      onPressed: () {
                        signInWithGoogle().then((user) {
                          if (user != null) {
                            print("로그인 성공: ${user.displayName}");
                            Get.to(SignInNameInput());
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;

  const _GoogleButton({
    required this.name,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('asset/img/glogo.png'),
          Text(
            name,
            style: TextStyle(color: Colors.black87, fontSize: 15.0),
          ),
          Opacity(
            opacity: 0.0,
            child: Image.asset('asset/img/glogo.png'),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        minimumSize: Size.fromHeight(50),
        elevation: 1.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
    );
  }
}
