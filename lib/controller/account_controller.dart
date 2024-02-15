import 'package:camera_pj/component/sign_in_component.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountController extends GetxController {
  var _userName = ''.obs;
  String _idToken = '';

  String get userName => _userName.value;

  set userName(String value) => _userName.value = value;

  RxString get idTokenRxString => _idToken.obs;

  String get idToken => _idToken;

  set idToken(String value) {
    _idToken = value;
    update();
  }

  Future<void> signUpWithGoogle(User? user) async {
    if (user == null) {
      print("로그인 실패");
      return;
    }
    idToken = (await user.getIdToken())!;
    print(userName);
    print(idToken);

    final dio = Dio();
    try {
      final response = await dio.post(
        'https://2cfd-119-202-37-52.ngrok-free.app/users/signUp/',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        }),
        data: {
          'name': userName,
        },
      );

      if (response.statusCode == 200) {
        print('회원가입 성공: ${response.data}');
      } else {
        print('회원가입 실패: ${response.data}');
      }
    } catch (e) {
      print('회원가입 요청 중 오류 발생: $e');
    }
  }
}
