import 'package:camera_pj/component/token_manager.dart';
import 'package:camera_pj/controller/account_controller.dart';
import 'package:camera_pj/screen/sign_in_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../screen/home_screen.dart';

void printLongString(String text) {
  final pattern = RegExp('.{1,800}'); // 800자 단위로 나눔
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print(googleAuth);
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (await TokenManager().getToken() == null) {
        final idToken = await userCredential.user?.getIdToken(true);
        await TokenManager().setToken(idToken!);
        print(idToken);
      }

      if (TokenManager().getFcmToken() == null) {
        await TokenManager().setFcmToken(fcmToken!);
      }
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

  final String? idToken = await TokenManager().getToken();
  final fcmToken = await TokenManager().getFcmToken();

  final dio = Dio();
  dio.interceptors.add(CustomInterceptor());

  try {
    final response = await dio.post(
      'http://pengy.dev/users/signIn/',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      }),
      data: {
        'fcmToken': fcmToken,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = response.data;
      print(response.data);
      Get.to(HomeScreen());
    } else if (response.statusCode == 404) {
      Get.to(SignInNameInput());
    } else {
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
