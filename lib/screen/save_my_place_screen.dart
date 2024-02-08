import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/address_controller.dart';


class SaveMyPlaceScreen extends StatelessWidget {
  SaveMyPlaceScreen({Key? key}) : super(key: key);

  final AddressController controller = Get.find<AddressController>();
  final TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                controller: nicknameController,
                decoration: InputDecoration(
                  labelText: 'Place Nickname',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
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
