import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/scan_controller.dart';
import 'camera_after_screen.dart';

List<Widget> displayBoxesAroundRecognizedObjects(
    Size screen,
    List<Map<String, dynamic>> yoloResults,
    int imageWidth,
    int imageHeight,
    ) {
  if (yoloResults.isEmpty) return [];

  double factorX = screen.width / imageWidth ;
  double factorY = screen.height / imageHeight / 2;
  Color colorPick = const Color.fromARGB(255, 50, 233, 30);
  return yoloResults.map((result) {
    double left = result["box"][0] * factorX;
    double top = result["box"][1] * factorY - 10;
    double right = result["box"][2] * factorX + 40;
    double bottom = result["box"][3] * factorY + 10;
    double fontSize = (bottom - top) * 0.2; // 텍스트 길이가 박스 높이의 70%가 되도록 설정
    double max = math.max(right - left + 50,bottom - top);

    return Positioned(
      left: left,
      top: top + 20,
      child: Container(
        width: right - left + 100,
        height: bottom - top + 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.pink, width: 2.0),
        ),
        child: Text(
          "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
          style: TextStyle(
            background: Paint()..color = colorPick,
            color: Colors.white,
            fontSize: math.min(fontSize, 18.0),
          ),
        ),
      ),
    );
  }
  ).toList();
}

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanController controller = Get.put(ScanController()); // ScanController 초기화
    controller.setObjectDetectionInProgress(false);
    print(controller.objectDetectionInProgress);
    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    var width = controller.imageWidth.value;
    var height = controller.imageHeight.value;
    var previewH = math.max(height, width);
    var previewW = math.min(height, width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: GetBuilder<ScanController>(
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller.cameraController),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.black.withOpacity(0.5),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detected Objects:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        if (controller.detectedObjects.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: controller.detectedObjects
                                .map((obj) => Text(
                              '- ${obj['tag']} ${obj['box'][4]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ))
                                .toList(),
                          ),
                      ],
                    );
                  }),
                ),
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: ElevatedButton(
                  onPressed: () async {
                    XFile? image = await controller.takePicture();
                    RxList<Map<String, dynamic>>? content =
                        controller.detectedObjects;
                    print("image: ${image?.path}");
                    print("content: $content");
                    if (image?.path != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DisplayDetectedObjectsScreen(
                                image: image!.path,
                                detectedObjects: controller.detectedObjects,
                                imageHeight: controller.imageHeight.value,
                                imageWidth: controller.imageWidth.value,
                              ),
                        ),
                      );
                    } else {
                      print('Failed to take picture');
                    }
                  },
                  child: Icon(Icons.camera),
                ),
              ),
              ...displayBoxesAroundRecognizedObjects(
                MediaQuery.of(context).size,
                controller.detectedObjects,
                controller.imageWidth.value,
                controller.imageHeight.value,
              ),
            ],
          )
              : Center(child: Text("Loading Preview..."));
        },
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
