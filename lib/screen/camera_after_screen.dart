import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera_pj/screen/information_screen.dart';
import 'package:flutter/material.dart';

List<Widget> displayBoxesAroundRecognizedObjects(
    Image image,
    Size screen,
    List<Map<String, dynamic>> yoloResults,
    int imageWidth,
    int imageHeight,
    Function(double left, double top, double right, double bottom) onTapCallback,
    ) {
  if (yoloResults.isEmpty) return [];

  double factorX = screen.width / imageWidth;
  double factorY = screen.height / imageHeight / 2;

  Color colorPick = const Color.fromARGB(255, 50, 233, 30);
  return yoloResults.map((result) {
    double left = result["box"][0] * factorX;
    double top = result["box"][1] * factorY - 10;
    double right = result["box"][2] * factorX + 25;
    double bottom = result["box"][3] * factorY + 10;
    double fontSize = (bottom - top); // 텍스트 길이가 박스 높이의 70%가 되도록 설정
    double rleft = result["box"][0];
    double rtop = result["box"][1];
    double rright = result["box"][2];
    double rbottom= result["box"][3];

    return Positioned(
      left: left,
      top: top + 20,
      child: GestureDetector(
        onTap: () {
          onTapCallback(rleft, rtop, rright, rbottom);
          print('Tag: ${result['tag']}');
        },
        child: Container(
          width: right - left,
          height: bottom - top,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
        ),
      ),
    );
  }).toList();
}

class DisplayDetectedObjectsScreen extends StatelessWidget {
  final String image;
  final List<Map<String, dynamic>>? detectedObjects;
  final int imageWidth;
  final int imageHeight;

  DisplayDetectedObjectsScreen({
    required this.image,
    required this.detectedObjects,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            if (image != null)
              Container(
                width: size.width,
                height: size.height,
                child: Image.file(
                  File(image),
                  fit: BoxFit.cover,
                ),
              ),
            ...displayBoxesAroundRecognizedObjects(
              Image.file(File(image)),
              size,
              detectedObjects!,
              imageWidth,
              imageHeight,
                  (double left, double top, double right, double bottom) {
                cropAndShowModal(left, top, right, bottom, image, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void cropAndShowModal(
      double left,
      double top,
      double right,
      double bottom,
      String imagePath,
      BuildContext context,
      ) async {
    // 자르기 영역 계산
    int cropLeft = left.toInt();
    int cropTop = top.toInt();
    int cropWidth = (right - left).toInt();
    int cropHeight = (bottom - top).toInt();

    // 이미지 자르기
    File croppedImage = await cropImage(File(imagePath), cropLeft, cropTop, cropWidth, cropHeight);

    // 모달에서 자른 이미지 보여주기
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
      builder: (BuildContext context) {
        return Center( // Center 위젯을 사용하여 모달을 화면 중앙에 배치
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80% 크기로 설정
            height: MediaQuery.of(context).size.height * 0.8, // 화면 높이의 80% 크기로 설정
            child: Column(
              mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 최소로 설정하여 내용에 맞게 크기 조정
              children: [
                ClipOval(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6, // 이미지의 가로 크기를 화면 너비의 60%로 설정
                    height: MediaQuery.of(context).size.width * 0.6, // 이미지의 세로 크기를 화면 너비의 60%로 설정
                    child: Image.file(
                      croppedImage,
                      fit: BoxFit.cover,
                      scale: 5.0, // 이미지가 모달 창 전체를 채우도록 설정
                    ),
                  ),
                ),
                SizedBox(height: 20), // 버튼과 이미지 사이에 여백 추가
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 버튼을 중앙 정렬
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print(croppedImage);
                        // 여기에 예 버튼 동작을 처리하세요
                        Navigator.pop(context); // 모달 닫기
                        // 페이지 이동 코드 추가
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => InformationScreen()), // 이동할 페이지 지정
                        // );
                      },
                      child: Text('예'),
                    ),
                    SizedBox(width: 20), // 버튼 사이에 간격 추가
                    ElevatedButton(
                      onPressed: () {
                        // 여기에 아니요 버튼 동작을 처리하세요
                        Navigator.pop(context); // 모달 닫기
                      },
                      child: Text('아니요'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );


  }


  Future<File> cropImage(File imageFile, int left, int top, int width, int height) async {
    // Read the image
    Uint8List imageBytes = await imageFile.readAsBytes();

    // Decode the image
    ui.Image originalImage = await decodeImageFromList(imageBytes);

    // Crop the image
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;
    canvas.drawImageRect(originalImage, Rect.fromLTRB(left.toDouble(), top.toDouble(), (left + width).toDouble(), (top + height).toDouble()), Rect.fromLTRB(0, 0, width.toDouble(), height.toDouble()), paint);
    final croppedImage = await recorder.endRecording().toImage(width, height);

    // Save the cropped image to file
    final croppedByteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    List<int> croppedBytes = croppedByteData!.buffer.asUint8List();
    File croppedFile = File('${imageFile.path}_cropped.png');
    await croppedFile.writeAsBytes(croppedBytes);

    return croppedFile;
  }
}
