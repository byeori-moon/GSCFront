import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../component/token_manager.dart';

class FireHazard {
  final int id;
  final String object;

  FireHazard({
    required this.id,
    required this.object,
  });

  factory FireHazard.fromJson(Map<String, dynamic> json) {
    return FireHazard(
      id: json['id'],
      object: json['object'],
    );
  }
}
class GoogleNewsData {
  final String title;
  final String link;

  GoogleNewsData({required this.title, required this.link});

  factory GoogleNewsData.fromJson(Map<String, dynamic> json) {
    return GoogleNewsData(
      title: json['title'],
      link: json['link'],
    );
  }
}
class ScholarlyData {
  final String title;
  final List<String> authors;
  final String pubYear;
  final String venue;
  final String abstract;
  final String pubUrl;

  ScholarlyData({
    required this.title,
    required this.authors,
    required this.pubYear,
    required this.venue,
    required this.abstract,
    required this.pubUrl,
  });

  factory ScholarlyData.fromJson(Map<String, dynamic> json) {
    return ScholarlyData(
      title: json['title'],
      authors: List<String>.from(json['authors'].split("，")), // Assuming authors are separated by "，"
      pubYear: json['pub_year'],
      venue: json['venue'],
      abstract: json['abstract'],
      pubUrl: json['pub_url'],
    );
  }
}

class ObjectInformationData{
  final FireHazard fireHazard;
  final List<GoogleNewsData> googleNewsData;
  final List<ScholarlyData> scholarlyData;
  final String youtubeVideoLinks;

  ObjectInformationData({
    required this.fireHazard,
    required this.googleNewsData,
    required this.scholarlyData,
    required this.youtubeVideoLinks,
  });

  factory ObjectInformationData.fromJson(Map<String, dynamic> json) {
    return ObjectInformationData(
      fireHazard: FireHazard.fromJson(json['fire_hazard']),
      googleNewsData: (json['google_news_data'] as List)
          .map((e) => GoogleNewsData.fromJson(e))
          .toList(),
      scholarlyData: (json['scholarly_data'] as List)
          .map((e) => ScholarlyData.fromJson(e))
          .toList(),
      youtubeVideoLinks: json['youtube_video_links'],
    );
  }
}

class ObjectController extends GetxController {
  ObjectInformationData? objectInformationData;

  Future<ObjectInformationData> getInformation(String objectId) async {
    final dio = Dio();

    try {
      final idToken = await TokenManager().getToken();
      if (idToken != null) {
        final response = await dio.get(
          'https://pengy.dev/api/edu-contents/get-contents/$objectId/',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          }),
        );

        if (response.statusCode == 200) {
          print('edu-content 가져오기 성공: ${response.data}');
          objectInformationData=ObjectInformationData.fromJson(response.data);

        } else {
          print('edu-content 가져오기 실패: ${response.data}');
        }
      }
      return objectInformationData!;

    } catch (e) {
      print('edu-content 가져오기 요청 중 오류 발생: $e');
      return objectInformationData!;

    }
  }

}