import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera_pj/controller/scan_controller.dart';
import 'package:camera_pj/controller/space_controller.dart';
import 'package:camera_pj/screen/information_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:get/get_core/src/get_main.dart';
import 'package:image/image.dart' as img;
import 'dart:math' as math;

import '../component/token_manager.dart';

String? selectedLabel; // 추가: 선택된 라벨을 저장할 변수

// 이미지를 1:1 비율로 조정하는 함수
Future<File> resizeImage(File imageFile, int size) async {
  // 이미지 파일을 읽어옴
  img.Image image = img.decodeImage(await imageFile.readAsBytes())!;

  // 이미지의 가로와 세로 중 작은 쪽을 기준으로 1:1 비율로 조정
  img.Image resizedImage = img.copyResizeCropSquare(image, size: size);

  // 조정된 이미지를 파일로 저장
  File resizedFile = File('${imageFile.path}_resized.jpg');
  await resizedFile.writeAsBytes(img.encodeJpg(resizedImage));

  return resizedFile;
}

List<Widget> displayBoxesAroundRecognizedObjects(
    Image image,
    Size screen,
    List<Map<String, dynamic>> yoloResults,
    int imageWidth,
    int imageHeight,
    Function(double left, double top, double right, double bottom) onTapCallback,
    ) {
  if (yoloResults.isEmpty) return [];

  double factorX = screen.width / imageWidth ;
  double factorY = screen.height / imageHeight / 2;

  Color colorPick = const Color.fromARGB(255, 50, 233, 30);
  return yoloResults.map((result) {
    double left = result["box"][0] * factorX + 10;
    double top = result["box"][1] * factorY - 10;
    double right = result["box"][2] * factorX + 40;
    double bottom = result["box"][3] * factorY + 20;
    double fontSize = (bottom - top) * 0.2; // 텍스트 길이가 박스 높이의 70%가 되도록 설정 텍스트 길이가 박스 높이의 70%가 되도록 설정
    double rleft = result["box"][0];
    double rtop = result["box"][1];
    double rright = result["box"][2];
    double rbottom = result["box"][3];
    double max = math.max(right - left + 50,bottom - top);

    return Positioned(
      left: left,
      top: top + 20,
      child: GestureDetector(
        onTap: () {
          onTapCallback(rleft, rtop, rright, rbottom);
          print('Tag: ${result['tag']}');
          selectedLabel = result['tag']; // 클릭된 객체의 라벨을 저장

        },
        child: Container(
          width: right - left + 100,
          height: bottom - top + 50,
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



  void saveObject(int space,int hazard,var path,String name) async {
    // TODO: 여기에 실제 저장 로직 구현

    final dio = Dio(BaseOptions(
      followRedirects: true,
      maxRedirects: 5, // 최대 리디렉션 횟수
    ));

    final String? idToken = await TokenManager().getToken();
    try {
      FormData formData = FormData.fromMap({
        'my_space': space,
        'fire_hazard': hazard,
        // 'thumbnail_image': await MultipartFile.fromFile(path),
        'nickname': name,
      });
      final response = await dio.post(
        'https://pengy.dev/api/spaces/hazards/',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        }),
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('물체등록 성공: ${response.data}');

        Get.to(InformationScreen(objectId: "$hazard", type: false));

      } else {
        print('물체등록 실패: ${response.data}');
      }
    } catch (e) {
      print(path);
      // Get.to(InformationScreen(objectId: "$hazard",type: true));
      print('물체등록 요청 중 오류 발생: $e');
    }
  }


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
    int cropLeft = left.toInt() + 10;
    int cropTop = top.toInt() -10;
    int cropWidth = (right - left).toInt() + 100;
    int cropHeight = (bottom - top).toInt() + 50;

    // 이미지 자르기
    File croppedImage = await cropImage(
        File(imagePath), cropLeft, cropTop, cropWidth, cropHeight);
    File resizedImage = await resizeImage(croppedImage, 300);

    String? objectName = null;
    final spaceController = Get.find<SpaceController>(); // 가정한 ScanController 가져오기
    int selectedTag = spaceController.spaces[0].id; // 선택된 태그를 저장하는 변수

    showModalBottomSheet(

      context: context,
      backgroundColor: Colors.white.withOpacity(0.5),
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '이름',
                          hintText: '이름을 입력하세요',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          objectName = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: '태그 선택',
                          labelStyle: TextStyle(fontFamily: 'OHSQUAREAIR'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        value: selectedTag,
                        items: spaceController.spaces.map((space) {
                          return DropdownMenuItem<int>(
                            child: Text(space.spaceName),
                            value: space.id,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          // 선택된 태그 업데이트
                          selectedTag = newValue!;
                        },
                      ),
                    ),

                  ],
                ),

                // 이름 입력란

                SizedBox(height: 20),                // 예/아니오 버튼
                Text(
                  "${selectedLabel}",
                  style: TextStyle(
                    fontSize: 25, // 글꼴 크기 지정
                    fontWeight: FontWeight.bold,
                    // 다른 스타일 속성들
                  ),
                ),                SizedBox(height: 20),                // 예/아니오 버튼

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(

                      onPressed: () {
                        // 예를 누르면 정보를 저장하고 화면 이동
                        print(objectName);
                        print(selectedTag);
                        String sendData = '';
                        if (croppedImage != null) {
                           sendData = resizedImage.path;
                        }
                        if(objectName!.isNotEmpty){
                          var stc =3;
                          if(selectedLabel=="refrigerator") stc = 3;
                          else if (selectedLabel=="air conditioner") stc = 4;
                          else if (selectedTag=="power soket") stc =2;
                          else if (selectedTag=="gas_stove") stc =1;
                          else if (selectedTag=="washing machine") stc = 7;
                          else if (selectedTag=="wood boiler")stc=6;

                            saveObject(selectedTag,stc,sendData,objectName!);
//                        print(selectedLabel);
                          Get.to(InformationScreen(objectId: "$stc", type: true));
                        }

                        // saveObjectAndNavigate(objectName, objectTag);
                      },
                      child: Text('예'),
                    ),
                    SizedBox(width: 20),

                    ElevatedButton(
                      onPressed: () {
                        // 아니요를 누르면 모달 닫기
                        Navigator.pop(context);
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

  Future<File> cropImage(
      File imageFile, int left, int top, int width, int height) async {
    // Read the image
    Uint8List imageBytes = await imageFile.readAsBytes();

    // Decode the image
    ui.Image originalImage = await decodeImageFromList(imageBytes);

    // Crop the image
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;
    canvas.drawImageRect(
        originalImage,
        Rect.fromLTRB(left.toDouble(), top.toDouble(),
            (left + width).toDouble(), (top + height).toDouble()),
        Rect.fromLTRB(0, 0, width.toDouble(), height.toDouble()),
        paint);
    final croppedImage = await recorder.endRecording().toImage(width, height);

    // Save the cropped image to file
    final croppedByteData = await croppedImage.toByteData(
        format: ui.ImageByteFormat.png);
    List<int> croppedBytes = croppedByteData!.buffer.asUint8List();
    File croppedFile =
    File('${imageFile.path}');
    await croppedFile.writeAsBytes(croppedBytes);

    return croppedFile;
  }

}
