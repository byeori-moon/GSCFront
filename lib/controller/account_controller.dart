import 'package:camera_pj/component/sign_in_component.dart';
import 'package:camera_pj/component/token_manager.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountController extends GetxController {
  Future<void> signUpWithGoogle(String userName) async {
    final String? idToken = await TokenManager().getToken();
    print(idToken);

    final dio = Dio();
    try {
      final response = await dio.post(
        'https://fire-61d9a.du.r.appspot.com/users/signUp/',
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
