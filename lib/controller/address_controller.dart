import 'package:get/get.dart';

class AddressController extends GetxController {
  var placeName = ''.obs;
  var placeAddress = ''.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  void updatePlace(String name, String address, double lat, double lng) {
    placeName.value = name;
    placeAddress.value = address;
    latitude.value = lat;
    longitude.value = lng;
  }
}