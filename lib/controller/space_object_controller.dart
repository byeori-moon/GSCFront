import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../component/token_manager.dart';
import 'account_controller.dart';
class FireHazard {
  final int id;
  final String object;

  FireHazard({required this.id, required this.object});

  factory FireHazard.fromJson(Map<String, dynamic> json) {
    return FireHazard(
      id: json['id'],
      object: json['object'],
    );
  }
}
class UserFireHazard {
  final int id;
  final FireHazard fireHazard;
  final bool isChecked;

  UserFireHazard({required this.id, required this.fireHazard, required this.isChecked});

  factory UserFireHazard.fromJson(Map<String, dynamic> json) {
    return UserFireHazard(
      id: json['id'],
      fireHazard: FireHazard.fromJson(json['fire_hazard']),
      isChecked: json['is_checked'],
    );
  }
}

class SpaceDetail {
  final int id;
  final String thumbnailImage;
  final String nickname;
  final int mySpace;

  SpaceDetail({
    required this.id,
    required this.thumbnailImage,
    required this.nickname,
    required this.mySpace,

  });

  factory SpaceDetail.fromJson(Map<String, dynamic> json) {
    print("parsed space objects: ${json}");
    return SpaceDetail(
      id: json['id'],
      thumbnailImage: json['thumbnail_image'],
      nickname: json['nickname'],
      mySpace: json['my_space'],

    );
  }
}

class FireAssessment {
  final int id;
  final int mySpaceDetail;
  final String nickname;
  final String placeOrObjectDescription;
  final int degreeOfFireDanger;
  final String identifiedFireHazards;
  final String mitigationMeasures;
  final String additionalRecommendations;
  final String factCheck;

  FireAssessment({
    required this.id,
    required this.mySpaceDetail,
    required this.nickname,
    required this.placeOrObjectDescription,
    required this.degreeOfFireDanger,
    required this.identifiedFireHazards,
    required this.mitigationMeasures,
    required this.additionalRecommendations,
    required this.factCheck,
  });

  factory FireAssessment.fromJson(Map<String, dynamic> json) {
    return FireAssessment(
      id: json['id'],
      mySpaceDetail: json['my_space_detail'],
      nickname: json['nickname'],
      placeOrObjectDescription: json['place_or_object_description'],
      degreeOfFireDanger: json['degree_of_fire_danger'].toInt(),
      identifiedFireHazards: json['identified_fire_hazards'],
      mitigationMeasures: json['mitigation_measures'],
      additionalRecommendations: json['additional_recommendations'],
      factCheck: json['fact_check'],
    );
  }
}

class SpaceObjectController extends GetxController {
  List<SpaceDetail> spaceDetails = <SpaceDetail>[].obs;
  List<UserFireHazard> fireHazardDetails = [];
  FireAssessment? fireAssessment;

  @override
  void onInit() {
    super.onInit();
  }

  final Dio dio = Dio();

  Future<List<SpaceDetail>> fetchSpaceObjects(int spaceId) async {
    List<SpaceDetail> spaceDetails = [];
    try {
      // dio.interceptors.add(CustomInterceptor());
      final idToken = await TokenManager().getToken();
      final response = await dio.get(
        'https://pengy.dev/api/spaces/myspace/$spaceId/',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        }),
      );

      if (response.statusCode == 200) {
        print("Fetched space objects: ${response.data}");
        print("Fetched space detail objects: ${response.data['space_details']}");

        List<dynamic> details = response.data['space_details'];

        var fetchedObjects = List<SpaceDetail>.from(
            details.map((json) => SpaceDetail.fromJson(json))
        );
        this.spaceDetails.assignAll(fetchedObjects);
      } else {
        print('Failed to load space objects with status code: ${response.statusCode}');
      }
      return spaceDetails;
    } catch (e) {
      print("Error fetching space objects: ${e.toString()}");
    }
    return spaceDetails;
  }

  Future<List<UserFireHazard>> fetchFireHazardDetails(int id) async {

    try{
    final idToken = await TokenManager().getToken();
    final response = await dio.get('http://pengy.dev/api/fire-hazards/myspace_detail/$id',
      options: Options(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    }),
    );
    if (response.statusCode == 200) {
      print("Fetched space objects: ${response.data}");

      List<dynamic> data = response.data;
      fireHazardDetails = data.map((json) => UserFireHazard.fromJson(json)).toList();

      return fireHazardDetails;
    }else {
      print('Failed to load space objects with status code: ${response.statusCode}');
      return fireHazardDetails;

    }}
    catch (e) {
    print("Error fetching space objects: ${e.toString()}");
    return fireHazardDetails;

    }
  }

  Future<FireAssessment> getFireAssessment(int mySpaceDetailId) async {
    final dio = Dio();

    try {
      final idToken = await TokenManager().getToken();
      final response = await dio.get(
        'http://pengy.dev/api/spaces/get-vision-result/$mySpaceDetailId',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        }),
      );

      if (response.statusCode == 200) {
        print("Fetched getFireAssessment objects: ${response.data}");

        fireAssessment = FireAssessment.fromJson(response.data[0]);
      } else {
        throw Exception('Failed to load fire assessment data');
      }
      return fireAssessment!;

    } catch (e) {
      print('Error fetching fire assessment data: $e');
      throw Exception('Error fetching fire assessment data');

    }
  }
}
