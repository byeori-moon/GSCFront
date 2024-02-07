import 'package:camera_pj/pages/camera.dart';
import 'package:camera_pj/pages/mainPage.dart';
import 'package:camera_pj/screen/home_screen.dart';
import 'package:camera_pj/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    home: LoginScreen(),
  ),);
}

