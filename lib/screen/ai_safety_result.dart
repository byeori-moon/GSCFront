import 'package:camera_pj/component/temperature_component.dart';
import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/controller/object_controller.dart';
import 'package:camera_pj/controller/space_object_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'camera_after_screen.dart';

class AISafetyResultScreen extends StatefulWidget {
  final int spaceId;
  final bool type;
  final String imgUrl;

  AISafetyResultScreen(
      {required this.spaceId, required this.type, required this.imgUrl});

  @override
  State<AISafetyResultScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<AISafetyResultScreen> {
  final SpaceObjectController objectController =
      Get.put(SpaceObjectController());

  @override
  void initState() {
    super.initState();
  }

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        backgroundColor: BACKGROUND_COLOR,
        body: Center(
            child: FutureBuilder<FireAssessment>(
                future: objectController.getFireAssessment(widget.spaceId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final _loadedData = snapshot.data;

                  return ListView(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('asset/img/ai_result_penguin.png'),
                            Text(
                              // _loadedData!.fireHazard.object,
                              "AI안전진단 결과 안내",
                              style: TextStyle(
                                  fontFamily: 'OHSQUARE',
                                  fontSize: 30,
                                  color: BUTTON_BLUE),
                            ),
                            SizedBox(
                              height: 40,
                              child: widget.type
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: BUTTON_BLUE,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                      ),
                                      onPressed: () {
                                        // 버튼이 눌렸을 때 수행할 동작 추가
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            'add MySpace',
                                            style: TextStyle(
                                              fontFamily: 'OHSQUARE',
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(), // widget.type이 false인 경우 빈 SizedBox 반환
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                '🔥Degree of Fire Danger',
                                style: TextStyle(
                                    fontFamily: 'OHSQUARE',
                                    fontSize: 22,
                                    color: BUTTON_BLUE),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 20,),
                                Column(
                                  children: [
                                    SizedBox(
                                        width: 40,
                                        child: ThermometerWidget(
                                            temperature: _loadedData!
                                                .degreeOfFireDanger
                                                .toDouble())),
                                    Text(_loadedData!.degreeOfFireDanger
                                        .toString() +
                                        '`C',style: TextStyle(
                                      fontFamily: 'OHSQUARE',)),
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),

                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: SHADOW_BLUE,
                                          blurRadius: 4,
                                          offset: Offset(2, 2), // 그림자의 방향
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // 내용을 왼쪽 정렬
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Image.network(widget.imgUrl,
                                              fit: BoxFit.cover),
                                        ),
                                        Text(
                                          _loadedData!.placeOrObjectDescription,
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            ListTile(
                              title: Text(
                                '🔥Identified Fire Hazards',
                                style: TextStyle(
                                    fontFamily: 'OHSQUARE',
                                    fontSize: 22,
                                    color: BUTTON_BLUE),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: SHADOW_BLUE,
                                    blurRadius: 4,
                                    offset: Offset(2, 2), // 그림자의 방향
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _loadedData!.identifiedFireHazards
                                      .split(', ')
                                      .map((String hazard) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Row(
                                              children: [
                                                Text('🧨'),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '$hazard',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontFamily:
                                                            'OHSQUAREAIR'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                '🔥Mitigation Measures',
                                style: TextStyle(
                                    fontFamily: 'OHSQUARE',
                                    fontSize: 22,
                                    color: BUTTON_BLUE),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: SHADOW_BLUE,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _loadedData!.mitigationMeasures
                                      .split('\n') // 각 줄을 분리
                                      .map((String measure) {
                                        String numberEmoji;
                                        if (measure.startsWith('1.')) {
                                          numberEmoji = '🔴 ';
                                        } else if (measure.startsWith('2.')) {
                                          numberEmoji = '🟠 ';
                                        } else if (measure.startsWith('3.')) {
                                          numberEmoji = '🟢 ';
                                        } else {
                                          numberEmoji = '';
                                        }
                                        List<TextSpan> spans =
                                            []; // TextSpan 리스트 생성
                                        final RegExp exp = RegExp(
                                            r'\*\*(.*?)\*\*'); // 정규식으로 볼드 처리할 텍스트 찾기
                                        String text =
                                            measure.substring(3); // 숫자와 점 제거
                                        text.splitMapJoin(
                                          exp,
                                          onMatch: (Match m) {
                                            spans.add(TextSpan(
                                                text: m.group(1),
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold))); // 볼드 처리
                                            return '';
                                          },
                                          onNonMatch: (String text) {
                                            spans.add(TextSpan(
                                                text: text)); // 일반 텍스트 처리
                                            return '';
                                          },
                                        );
                                        return Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'OHSQUAREAIR',
                                                  color: Colors.black),
                                              children: [
                                                TextSpan(text: '$numberEmoji '),
                                                // 이모지 추가
                                                ...spans,
                                                // 볼드 및 일반 텍스트 스팬
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                      .expand((element) => [
                                            element,
                                            Divider()
                                          ]) // 각 요소 뒤에 Divider 추가
                                      .toList()
                                    ..removeLast(), // 마지막 Divider 제거
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                '📜 Additional Information',
                                style: TextStyle(
                                    fontFamily: 'OHSQUARE',
                                    fontSize: 22,
                                    color: BUTTON_BLUE),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: SHADOW_BLUE,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                title: Text('More Information',
                                    style: TextStyle(
                                        fontFamily: 'OHSQUARE', fontSize: 16)),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: 'OHSQUAREAIR',
                                            height: 1.5),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                'Additional Recommendations: \n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: _loadedData
                                                .additionalRecommendations,
                                          ),
                                          TextSpan(
                                            text: '\n\nFact Check: \n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: _loadedData.factCheck,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset('asset/img/default_character_bottom.png'),
                    ],
                  );
                })));
  }
}

class DocumentWebView extends StatefulWidget {
  final String url;

  DocumentWebView(this.url);

  @override
  State<DocumentWebView> createState() => _DocumentWebViewState();
}

class _DocumentWebViewState extends State<DocumentWebView> {
  late Uri documentUrl;

  @override
  void initState() {
    super.initState();
    documentUrl = Uri.parse(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(documentUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text('📜 관련 논문'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}

class NewsWebView extends StatefulWidget {
  final String url;

  NewsWebView(this.url);

  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  late Uri newsUrl;

  @override
  void initState() {
    super.initState();
    newsUrl = Uri.parse(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(newsUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text('🔥 화재 사례'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
