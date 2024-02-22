
import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/controller/object_controller.dart';
import 'package:camera_pj/pages/main_page.dart';
import 'package:camera_pj/screen/map_screen.dart';
import 'package:camera_pj/screen/home_screen.dart';
import 'package:camera_pj/screen/information_screen.dart';
import 'package:camera_pj/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'controller/account_controller.dart';
import 'controller/quiz_controller.dart';
import 'controller/space_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");	// 추가
  await Firebase.initializeApp();
  Get.put(AccountController());
  Get.put(SpaceController());
  Get.put(ObjectController());
  Get.put(QuizController());
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        shadowColor: SHADOW_BLUE,
        fontFamily: 'OHSQUAREAIR'
      ),

      home: LoginScreen(),
    ),
  );
}
