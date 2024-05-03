import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/controller/object_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'camera_after_screen.dart';


class InformationScreen extends StatefulWidget {
  final String objectId;
  final bool type;
  InformationScreen({required this.objectId, required this.type});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final ObjectController objectController = Get.put(ObjectController());

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
            child: FutureBuilder<ObjectInformationData>(
                future: objectController.getInformation(widget.objectId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final _loadedData=snapshot.data;

                  final YoutubePlayerController _con = YoutubePlayerController(
                    initialVideoId: _loadedData!.youtubeVideoLinks,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  );
                  return ListView(

                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _loadedData!.fireHazard.object,
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
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                                onPressed: () {
                                  // 버튼이 눌렸을 때 수행할 동작 추가
                                },
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
                                '🔥Fire incident',
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
                                            _loadedData!
                                                .googleNewsData[0].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'OHSQUAREAIR'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsWebView(
                                            objectController
                                                .objectInformationData!
                                                .googleNewsData[0]
                                                .link),
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
                                            _loadedData!
                                                .googleNewsData[1].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'OHSQUAREAIR'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsWebView(
                                            objectController
                                                .objectInformationData!
                                                .googleNewsData[1]
                                                .link),
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
                                            _loadedData!
                                                .googleNewsData[2].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'OHSQUAREAIR'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsWebView(
                                            objectController
                                                .objectInformationData!
                                                .googleNewsData[2]
                                                .link),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ListTile(
                            //   title: Text(
                            //     '❗The Safety Method',
                            //     style: TextStyle(
                            //         fontFamily: 'OHSQUARE',
                            //         fontSize: 22,
                            //         color: BUTTON_BLUE),
                            //   ),
                            //   subtitle: Text(
                            //     'Attention',
                            //     style: TextStyle(
                            //         fontFamily: 'OHSQUAREAIR',
                            //         fontSize: 14,
                            //         color: BUTTON_BLUE),
                            //   ),
                            // ),
                            // Container(
                            //   padding: EdgeInsets.all(20),
                            //   margin: EdgeInsets.all(4),
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(20),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: SHADOW_BLUE,
                            //         blurRadius: 4,
                            //         offset: Offset(2, 2), // 그림자의 방향
                            //       ),
                            //     ],
                            //   ),
                            //   child: Column(
                            //     children: lines
                            //         .map((line) => Column(
                            //               children: [
                            //                 Text(
                            //                   line,
                            //                   style: TextStyle(
                            //                       fontSize: 16.0,
                            //                       fontFamily: 'OHSQUAREAIR'),
                            //                 ),
                            //                 if (line != lines.last) Divider(),
                            //               ],
                            //             ))
                            //         .toList(),
                            //   ),
                            // ),
                            ListTile(
                              title: Text(
                                '📺 Youtube Videos',
                                style: TextStyle(
                                    fontFamily: 'OHSQUARE',
                                    fontSize: 22,
                                    color: BUTTON_BLUE),
                              ),
                              subtitle: Text(
                                'Watch related videos.',
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
                                '📜 Related papers',
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
                                            text: 'title: \n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUARE',
                                                fontSize: 16)),
                                        TextSpan(
                                            text:
                                                '${_loadedData!.scholarlyData[0].title}\n\n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUAREAIR',
                                                fontSize: 15,
                                                height: 1.5)),
                                        TextSpan(
                                            text: 'author: \n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUARE',
                                                fontSize: 16)),
                                        TextSpan(
                                            text:
                                                '${_loadedData!.scholarlyData[0].authors}\n\n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUAREAIR',
                                                fontSize: 15,
                                                height: 1.5)),
                                        TextSpan(
                                            text: 'year: \n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUARE',
                                                fontSize: 16)),
                                        TextSpan(
                                            text:
                                                '${_loadedData!.scholarlyData[0].pubYear}\n\n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUAREAIR',
                                                fontSize: 15,
                                                height: 1.5)),
                                        TextSpan(
                                            text: 'publisher: \n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUARE',
                                                fontSize: 16)),
                                        TextSpan(
                                            text:
                                                '${_loadedData!.scholarlyData[0].venue}\n\n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUAREAIR',
                                                fontSize: 15,
                                                height: 1.5)),
                                        TextSpan(
                                            text: 'summary: \n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUARE',
                                                fontSize: 16)),
                                        TextSpan(
                                            text:
                                                '${_loadedData!.scholarlyData[0].abstract}\n\n',
                                            style: TextStyle(
                                                fontFamily: 'OHSQUAREAIR',
                                                fontSize: 15,
                                                height: 1.5)),
                                        TextSpan(
                                          text: 'click to see paper',
                                          style: TextStyle(
                                            color: BUTTON_BLUE,
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: 'OHSQUAREAIR',
                                            fontSize: 18,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DocumentWebView(
                                                          objectController
                                                              .objectInformationData!
                                                              .scholarlyData[0]
                                                              .pubUrl),
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
                  );
                }
                )
        )

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