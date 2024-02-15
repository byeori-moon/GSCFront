import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screen/space_detail_screen.dart';


class Space {
  final int id;
  final int firebaseUID;
  final String category;
  final String spaceName;
  final String coordinates;
  final String address;

  Space({
    required this.id,
    required this.firebaseUID,
    required this.category,
    required this.spaceName,
    required this.coordinates,
    required this. address,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'],
      firebaseUID: json['FirebaseUID'],
      category: json['category'],
      spaceName: json['spaceName'],
      coordinates: json['coordinates'],
      address: json['address'],
    );
  }
}

Future<List<Space>> fetchMySpaces() async {
  var dio = Dio();
  final response = await dio.get('http://pengy.dev:8000/api/spaces/myspace');

  if (response.statusCode == 200) {
    List<dynamic> spacesJson = response.data;
    return spacesJson.map((json) => Space.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load my spaces');
  }
}

class SpaceController extends GetxController {
  var data = [
    {
      "id": 3,
      "FirebaseUID": 1,
      "category": "카페",
      "spaceName": "테스트카페",
      "coordinates": "39.5665, 126.9780",
      "address": "서울시 동작구 ..."
    },
    {
      "id": 3,
      "FirebaseUID": 1,
      "category": "카페",
      "spaceName": "테스트카페",
      "coordinates": "37.5665, 126.9780",
      "address": "서울시 동작구 ..."
    }
  ];
  var spaces = <Space>[].obs;

  @override
  void onInit() {
    super.onInit();
    var fetchedData = data as List;
    spaces.value = fetchedData.map((json) => Space.fromJson(json)).toList();
  }

  Set<Marker> getMarkers(BuildContext context) {
    return spaces.map((space) {
      var coords = space.coordinates.split(', ').map(double.parse).toList();
      return Marker(
        markerId: MarkerId('${space.id}'),
        position: LatLng(coords[0], coords[1]),
        infoWindow: InfoWindow(
          title: space.spaceName,
          snippet: space.category,
        ),
        onTap: () {
          _showModalBottomSheet(context, space);
        },
      );
    }).toSet();
  }

  void _showModalBottomSheet(BuildContext context, Space space) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Space: ${space.spaceName}"),
                Text("Category: ${space.category}"),
                Text("Address: ${space.address}"),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('View Details'),
                  onPressed: () {
                    // 여기서 Space의 상세 화면으로 이동
                    Get.to(() => SpaceDetailScreen(space: space));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
