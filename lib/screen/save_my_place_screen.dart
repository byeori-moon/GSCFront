import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/address_controller.dart';


class SaveMyPlaceScreen extends StatelessWidget {
  SaveMyPlaceScreen({Key? key}) : super(key: key);

  // AddressController 인스턴스를 Get을 통해 찾습니다.
  final AddressController controller = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    // Obx를 사용하여 AddressController의 변수가 업데이트 될 때마다 UI가 자동으로 업데이트되도록 합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text('Save My Place'),
      ),
      body: Obx(() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Place',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Name: ${controller.placeName}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Address: ${controller.placeAddress}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Latitude: ${controller.latitude}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Longitude: ${controller.longitude}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 사용자가 장소를 저장하고 싶을 때 수행할 작업
                  // 예: 서버에 장소 정보를 저장하는 로직
                  // 이 예제에서는 단순히 pop으로 돌아갑니다.
                  Get.back();
                },
                child: Text('Save Place'),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
