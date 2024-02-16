import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SpaceDetail {
  final int id;
  final int mySpace;
  final int fireHazard;
  final String thumbnailImage;
  final String nickname;

  SpaceDetail({
    required this.id,
    required this.mySpace,
    required this.fireHazard,
    required this.thumbnailImage,
    required this.nickname,
  });

  factory SpaceDetail.fromJson(Map<String, dynamic> json) {
    return SpaceDetail(
      id: json['id'],
      mySpace: json['my_space'],
      fireHazard: json['fire_hazard'],
      thumbnailImage: json['thumbnail_image'],
      nickname: json['nickname'],
    );
  }
}

class SpaceObjectController extends GetxController {

  var data = [{
    "id": 10, // 예를 들어 생성된 객체의 ID
    "my_space": 1,
    "fire_hazard": 4,
    "thumbnail_image": "path/to/thumbnail.jpg",
    "nickname": "WhilteRefrigerator"
  },{
    "id": 10, // 예를 들어 생성된 객체의 ID
    "my_space": 1,
    "fire_hazard": 4,
    "thumbnail_image": "path/to/thumbnail.jpg",
    "nickname": "WhilteRefrigerator"
  },{
    "id": 10, // 예를 들어 생성된 객체의 ID
    "my_space": 1,
    "fire_hazard": 4,
    "thumbnail_image": "path/to/thumbnail.jpg",
    "nickname": "WhilteRefrigerator"
  }];
  var spaceDetails = <SpaceDetail>[].obs;

  @override
  void onInit() {
    super.onInit();
    var fetchedData = data as List;
    spaceDetails.value = fetchedData.map((json) => SpaceDetail.fromJson(json)).toList();
  }
  final Dio dio = Dio();

  Future<void> fetchSpaceObjects(int spaceId) async {
    try {
      final response = await dio.get('http://pengy.dev:8000/api/spaces/myspace/$spaceId/');
      if (response.statusCode == 200) {
        var fetchedObjects = List<SpaceDetail>.from(response.data.map((json) => SpaceDetail.fromJson(json)));
        spaceDetails.value = fetchedObjects;
      } else {
        // 오류 처리
        print('Failed to load space objects');
      }
    } catch (e) {
      // 예외 처리
      print(e.toString());
    }
  }
}
