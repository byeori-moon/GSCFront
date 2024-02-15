import 'package:camera_pj/controller/account_controller.dart';
import 'package:camera_pj/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../screen/home_screen.dart';

String idToken='';
Future<void> getInformation() async{
  final dio = Dio();
  try {
    print(idToken);
    final response = await dio.get(
      'https://2cfd-119-202-37-52.ngrok-free.app/api/edu-contents/1/',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${idToken}',
      }),

    );

    if (response.statusCode == 200) {
      print('edu-content 가져오기 성공: ${response.data}');
    } else {
      print('edu-content 가져오기 실패: ${response.data}');
    }
  } catch (e) {
    print('edu-content 가져오기 요청 중 오류 발생: $e');
  }
}
Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<void> checkUserInfoAndNavigate(User? user) async {
  if (user == null) {
    print("로그인 실패");
    return;
  }

  idToken = (await user.getIdToken())!;
  final dio = Dio();

  try {
    final response = await dio.post(
      'https://2cfd-119-202-37-52.ngrok-free.app/users/signIn/',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      }),
      data: {
      },
    );

    if (response.statusCode == 200) {
      final responseBody = response.data;
      print(response.data);
      Get.to(HomeScreen());
    } else if(response.statusCode == 404){
      Get.to(SignInNameInput());
    }
    else {
      print("서버 에러: ${response.data}");
    }
  } catch (e) {
    print("Dio 에러: $e");
  }
}

void onGoogleSignInButtonPressed() {
  signInWithGoogle().then((user) {
    checkUserInfoAndNavigate(user);
  });
}
