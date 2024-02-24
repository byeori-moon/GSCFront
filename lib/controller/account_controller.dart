import 'package:camera_pj/component/sign_in_component.dart';
import 'package:camera_pj/component/token_manager.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 요청 로그 출력
    print("Request to: ${options.baseUrl}${options.path}");
    print("Method: ${options.method}");
    printLongString("Headers: ${options.headers}");
    print("Query parameters: ${options.queryParameters}");
    print("Data: ${options.data}");
    super.onRequest(options, handler);
  }
}
void printLongString(String text) {
  final pattern = RegExp('.{1,800}'); // 800자 단위로 나눔
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
class AccountController extends GetxController {
  Future<void> signUpWithGoogle(String userName) async {
    final String? idToken = await TokenManager().getToken();
    print(idToken);
    print(userName);

    final dio = Dio();
    try {
      dio.interceptors.add(CustomInterceptor());
      final response = await dio.post(
        'https://pengy.dev/users/signUp/',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        }),
        data: {
          'name': '$userName',
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
