import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../component/sign_in_component.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LoginButton(),
        ),
      ),
    );
  }
}

class LoginButton extends StatefulWidget {
  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // 추가적으로 필요한 스코프를 여기에 명시할 수 있습니다.
    ],
  );



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        signInWithGoogle().then((user) {
          if (user != null) {
            print("로그인 성공: ${user.displayName}");
          }
        });
      },
      child: Text("Google로 로그인"),
    );
  }
}
