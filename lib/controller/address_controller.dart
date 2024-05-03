import 'dart:convert';

import 'package:camera_pj/component/token_manager.dart';
import 'package:camera_pj/controller/account_controller.dart';
import 'package:camera_pj/screen/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  var placeName = ''.obs;
  var placeAddress = ''.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var placeNickname = ''.obs;




  void updatePlace(String name, String address, double lat, double lng) {
    placeName.value = name;
    placeAddress.value = address;
    latitude.value = lat;
    longitude.value = lng;
    update();
  }

  void savePlace(String nickname, String coordinates,String address,int category) async {
    // TODO: 여기에 실제 저장 로직 구현

    print(category);
    print(nickname);
    print(coordinates);
    print(address);

    final dio = Dio();


    try {
    final idToken = await TokenManager().getToken();



    // FormData 생성
    print(idToken);

    if (idToken != null) {
      dio.interceptors.add(CustomInterceptor());
        final response = await dio.post(
          'https://pengy.dev/api/spaces/myspace/create',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          }),
          data: {
            'category': category,
            'spaceName': nickname,
            'coordinates': coordinates,
            'address': address
          },
      );
      if (response.statusCode == 200||response.statusCode==201) {
        print('장소등록 성공: ${response.data}');
        Get.to(HomeScreen());

      } else {
        print('장소등록 실패: ${response.data}');
      }
      }else{

      }
    } catch (e) {
      print('장소등록 요청 중 오류 발생: $e');
    }

  }
}