import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/controller/object_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InformationScreen extends StatefulWidget {
  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final ObjectController objectController = Get.put(ObjectController());

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> lines = objectController
        .objectInformationData.fireSafetyInstructions
        .split('\n');
    final YoutubePlayerController _con = YoutubePlayerController(
      initialVideoId:
          objectController.objectInformationData.youtubeVideoLinks[0],
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  objectController.objectInformationData.fireHazard.object,
                  style: TextStyle(
                      fontFamily: 'OHSQUARE', fontSize: 30, color: BUTTON_BLUE),
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: BUTTON_BLUE,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        )),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 20,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '내 장소에 추가하기',
                          style: TextStyle(
                            fontFamily: 'OHSQUARE',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    '🔥 화재 사례',
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
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Icon(Icons.article_outlined, size: 20),
                            SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                objectController.objectInformationData
                                    .googleNewsData[0].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.0, fontFamily: 'OHSQUAREAIR'),
                              ),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsWebView(objectController
                                .objectInformationData.googleNewsData[0].link),
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Row(
                          children: [
                            Icon(Icons.article_outlined, size: 20),
                            SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                objectController.objectInformationData
                                    .googleNewsData[1].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.0, fontFamily: 'OHSQUAREAIR'),
                              ),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsWebView(objectController
                                .objectInformationData.googleNewsData[1].link),
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Row(
                          children: [
                            Icon(Icons.article_outlined, size: 20),
                            SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                objectController.objectInformationData
                                    .googleNewsData[2].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.0, fontFamily: 'OHSQUAREAIR'),
                              ),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsWebView(objectController
                                .objectInformationData.googleNewsData[2].link),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    '❗️안전하게 사용하는 법 \n(출처: 땡땡소방서)',
                    style: TextStyle(
                        fontFamily: 'OHSQUARE',
                        fontSize: 22,
                        color: BUTTON_BLUE),
                  ),
                  subtitle: Text(
                    '보일러의 안전한 사용법을 확인하세요.',
                    style: TextStyle(
                        fontFamily: 'OHSQUAREAIR',
                        fontSize: 14,
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
                        offset: Offset(2, 2), // 그림자의 방향
                      ),
                    ],
                  ),
                  child: Column(
                    children: lines
                        .map((line) => Column(
                              children: [
                                Text(
                                  line,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'OHSQUAREAIR'),
                                ),
                                if (line != lines.last) Divider(),
                              ],
                            ))
                        .toList(),
                  ),
                ),
                ListTile(
                  title: Text(
                    '📺 관련 Youtube 동영상',
                    style: TextStyle(
                        fontFamily: 'OHSQUARE',
                        fontSize: 22,
                        color: BUTTON_BLUE),
                  ),
                  subtitle: Text(
                    '관련 동영상을 시청하세요.',
                    style: TextStyle(
                        fontFamily: 'OHSQUAREAIR',
                        fontSize: 14,
                        color: BUTTON_BLUE),
                  ),
                ),
                YoutubePlayer(
                  controller: _con,
                ),
                ListTile(
                  title: Text(
                    '📜 관련 논문',
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
                        offset: Offset(2, 2), // 그림자의 방향
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: '제목: \n',
                                style: TextStyle(fontFamily: 'OHSQUARE',fontSize: 16)),
                            TextSpan(
                                text: '${objectController.objectInformationData.scholarlyData[0].title}\n\n',
                                style: TextStyle(fontFamily: 'OHSQUAREAIR',fontSize: 15,height: 1.5)),
                            TextSpan(
                                text: '저자: \n',
                                style: TextStyle(fontFamily: 'OHSQUARE',fontSize: 16)),
                            TextSpan(
                                text: '${objectController.objectInformationData.scholarlyData[0].authors}\n\n',
                                style: TextStyle(fontFamily: 'OHSQUAREAIR',fontSize: 15,height: 1.5)),
                            TextSpan(
                                text: '출판년도: \n',
                                style: TextStyle(fontFamily: 'OHSQUARE',fontSize: 16)),
                            TextSpan(
                                text: '${objectController.objectInformationData.scholarlyData[0].pubYear}\n\n',
                                style: TextStyle(fontFamily: 'OHSQUAREAIR',fontSize: 15,height: 1.5)),
                            TextSpan(
                                text: '출판지: \n',
                                style: TextStyle(fontFamily: 'OHSQUARE',fontSize: 16)),
                            TextSpan(
                                text: '${objectController.objectInformationData.scholarlyData[0].venue}\n\n',
                                style: TextStyle(fontFamily: 'OHSQUAREAIR',fontSize: 15,height: 1.5)),
                            TextSpan(
                                text: '요약: \n',
                                style: TextStyle(fontFamily: 'OHSQUARE',fontSize: 16)),
                            TextSpan(
                                text: '${objectController.objectInformationData.scholarlyData[0].abstract}\n\n',
                                style: TextStyle(fontFamily: 'OHSQUAREAIR',fontSize: 15,height: 1.5)),

                            TextSpan(
                              text: '이곳을 클릭해서 논문 보기',
                              style: TextStyle(
                                  color: BUTTON_BLUE,
                                  decoration: TextDecoration.underline,fontFamily: 'OHSQUAREAIR',fontSize: 18,),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DocumentWebView(
                                          objectController.objectInformationData
                                              .scholarlyData[0].pubUrl),
                                    ),
                                  );
                                },
                            )
                          ],
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
      ),
    );
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