import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:camera_pj/component/token_manager.dart';
import 'package:camera_pj/controller/account_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_vision/flutter_vision.dart';

class ScanController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isCameraInitialized = false.obs;
  var detectedObjects = <Map<String, dynamic>>[].obs;
  FlutterVision vision = FlutterVision();
  var objectDetectionInProgress = false.obs;
  void setObjectDetectionInProgress(bool value) {
    objectDetectionInProgress.value = value;
  }
  // RxInt 변수를 선언하여 cameraImage의 너비와 높이를 저장합니다.
  var imageWidth = RxInt(0);
  var imageHeight = RxInt(0);

  @override
  void onInit() {
    super.onInit();

    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    vision.closeYoloModel();
    cameraController.dispose();
    super.dispose();
  }

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(cameras[0], ResolutionPreset.max);

      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          // cameraImage의 너비와 높이를 Rx 변수에 할당합니다.
          imageWidth.value = image.width;
          imageHeight.value = image.height;
          objectDetection(image);
        });
        isCameraInitialized(true);
        update();
      });
    } else {
      print("Permission denied");
    }
  }

  initTFLite() async {
    await vision.loadYoloModel(
      labels: 'asset/labels2.txt',
      modelPath: 'asset/yolov5n.tflite',
      modelVersion: "yolov5",
      quantization: false,
      numThreads: 2,
      useGpu: false,
    );
  }

  objectDetection(CameraImage image) async {
    if (objectDetectionInProgress.value==true) return;

    final result = await vision.yoloOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );


    if (result.isNotEmpty) {
      detectedObjects.value = result;
      // print("h:${image.height} w:${image.width}");
      //print(detectedObjects);
      update();
    }
  }
  objectDetectionImage(File imageFile) async {
    if (imageFile.path.isNotEmpty) {
      objectDetectionInProgress(true);
      print(objectDetectionInProgress);
      Uint8List byte = await imageFile.readAsBytes();
      final image = await decodeImageFromList(byte);
      imageWidth.value = image.width;
      imageHeight.value = image.height;
      final result = await vision.yoloOnImage(
        bytesList: byte,
        imageHeight: image.height,
        imageWidth: image.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5,
      );
      if (result.isNotEmpty) {
        detectedObjects.value = result;
        //print("1:${detectedObjects}");
        update();
      }
    }
  }
  // 사진을 찍는 메서드
  Future<XFile?> takePicture() async {
    if (!cameraController.value.isInitialized) {
      print("Error: Camera controller is not initialized");
      return null;
    }

    try {
      // 이미지를 캡처합니다.
      XFile picture = await cameraController.takePicture();
      objectDetectionInProgress(true);

//      objectDetectionImage(picture as File);
      // 캡처한 이미지의 경로를 반환합니다.
      return picture;
    } catch (e) {
      print("Error capturing picture: $e");
      return null;
    }
  }

  void saveObject() async {
    // TODO: 여기에 실제 저장 로직 구현

    final dio = Dio(BaseOptions(
      followRedirects: true,
      maxRedirects: 5, // 최대 리디렉션 횟수
    ));
    final String? idToken = await TokenManager().getToken();
    try {
      dio.interceptors.add(CustomInterceptor());

      final response = await dio.post(
          'http://pengy.dev/api/spaces/hazards/',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          }),
          data:{
            "my_space": 6,
            "fire_hazard": 1,
            "thumbnail_image": "path/to/thumbnail.jpg",
            "nickname": "WhilteRefrigerator"
          }
      );
      if (response.statusCode == 200) {
        print('물체등록 성공: ${response.data}');
      } else {
        print('물체등록 실패: ${response.data}');
      }
    } catch (e) {
      print('물체등록 요청 중 오류 발생: $e');
    }

  }

}
