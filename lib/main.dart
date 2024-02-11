import 'package:camera_pj/pages/camera.dart';
import 'package:camera_pj/pages/main_page.dart';
import 'package:camera_pj/screen/home_screen.dart';
import 'package:camera_pj/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      home: MainPage(),
    ),
  );
}
