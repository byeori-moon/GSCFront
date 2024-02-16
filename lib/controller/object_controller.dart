import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../component/token_manager.dart';

class FireHazard {
  final int id;
  final String object;
  final int hazardCategory;

  FireHazard({
    required this.id,
    required this.object,
    required this.hazardCategory,
  });

  factory FireHazard.fromJson(Map<String, dynamic> json) {
    return FireHazard(
      id: json['id'],
      object: json['object'],
      hazardCategory: json['hazard_category'],
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
  final String fireSafetyInstructions;
  final List<String> youtubeVideoLinks;

  ObjectInformationData({
    required this.fireHazard,
    required this.googleNewsData,
    required this.scholarlyData,
    required this.fireSafetyInstructions,
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
      fireSafetyInstructions: json['fire_safety_instructions'],
      youtubeVideoLinks: List<String>.from(json['youtube_video_links']),
    );
  }
}


class ObjectController extends GetxController {
  var data={
    "fire_hazard": {
      "id": 8,
      "object": "화목보일러",
      "hazard_category": 3
    },
    "google_news_data": [
      {
        "title": "날씨 추워지면 ‘화목보일러 화재’ 급증…‘부주의’로 인한 화재 72% - 경향신문",
        "link": "https://news.google.com/rss/articles/CBMiLGh0dHBzOi8vbS5raGFuLmNvLmtyL2FydGljbGUvMjAyMzEwMTIwOTU3MDAx0gFKaHR0cHM6Ly9tLmtoYW4uY28ua3IvbmF0aW9uYWwvbmF0aW9uYWwtZ2VuZXJhbC9hcnRpY2xlLzIwMjMxMDEyMDk1NzAwMS9hbXA?oc=5"
      },
      {
        "title": "화목보일러 화재 대부분 '부주의 탓'…“안전 꼭 살펴야” - 전민일보",
        "link": "https://news.google.com/rss/articles/CBMiPGh0dHBzOi8vd3d3Lmplb25taW4uY28ua3IvbmV3cy9hcnRpY2xlVmlldy5odG1sP2lkeG5vPTM3MjMyNdIBAA?oc=5"
      },
      {
        "title": "충북 화목보일러 화재 10건 중 7건 부주의…예방수칙 준수 당부 - 연합뉴스",
        "link": "https://news.google.com/rss/articles/CBMiL2h0dHBzOi8vd3d3LnluYS5jby5rci92aWV3L0FLUjIwMjMxMDI0MDc5ODAwMDY00gExaHR0cHM6Ly9tLnluYS5jby5rci9hbXAvdmlldy9BS1IyMDIzMTAyNDA3OTgwMDA2NA?oc=5"
      }
    ],
    "youtube_video_links": [
      "Wzi3ED5baxE"
    ],
    "fire_safety_instructions": "1. **설치**: 보일러는 전문가에 의해 설치되어야 합니다. 설치는 안전하게 사용하는데 중요한 첫 단계입니다. 보일러를 설치할 때는 환기가 잘되는 곳에 설치해야 합니다.\r\n2. **점검**: 정기적인 보일러 점검을 통해 이상 징후를 조기에 찾아낼 수 있습니다. 보일러 점검은 전문가에게 맡기는 것이 가장 안전합니다.\r\n3. **사용방법**: 보일러 사용법을 정확히 숙지하는 것이 중요합니다. 모르는 것이 있다면 사용 설명서를 참고하거나 전문가의 도움을 청해주세요.\r\n4. **환기**: 보일러 사용 시 환기는 매우 중요합니다. 보일러가 가동되는 동안에는 항상 충분한 공기 공급이 이루어지도록 해야 합니다.\r\n5. **화재 예방**: 보일러 주변에는 가연성 물질을 두지 않아야 합니다. 또한, 보일러가 작동 중일 때는 절대로 불꽃을 가까이하지 마세요.\r\n6. **보일러 꺼짐**: 보일러를 사용하지 않을 때는 반드시 가스를 차단하고 전원을 끄는 것이 안전합니다.",
    "scholarly_data": [
      {
        "title": "화목보일러 화재위험성 연구",
        "authors": "홍석봉， 신홍수， 민대성， 곽맹걸",
        "pub_year": "2014",
        "venue": "한국화재조사학회 학술대회",
        "abstract": "wood boiler can also fire by increasing. This study was to investigate the fire prevention  measures are Eastern Fire Department fire investigators an...",
        "pub_url": "https://www.earticle.net/Article/A234440"
      }
    ]
  };

  late ObjectInformationData objectInformationData;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    objectInformationData = ObjectInformationData.fromJson(data);

  }
  Future<void> getInformation() async {
    final dio = Dio();
    try {
      final idToken = await TokenManager().getToken(); // 토큰 가져오기
      if (idToken != null) {
        final response = await dio.get(
          'https://2cfd-119-202-37-52.ngrok-free.app/api/edu-contents/1/',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          }),
        );

        if (response.statusCode == 200) {
          print('edu-content 가져오기 성공: ${response.data}');
        } else {
          print('edu-content 가져오기 실패: ${response.data}');
        }
      }
    } catch (e) {
      print('edu-content 가져오기 요청 중 오류 발생: $e');
    }
  }

}