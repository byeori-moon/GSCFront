import 'dart:collection';

import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/pages/camera.dart';
import 'package:camera_pj/pages/main_page.dart';
import 'package:camera_pj/pages/map_screen.dart';
import 'package:camera_pj/screen/home_screen.dart';
import 'package:camera_pj/screen/information_screen.dart';
import 'package:camera_pj/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/account_controller.dart';
import 'controller/space_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AccountController());
  Get.put(SpaceController());

  runApp(
    GetMaterialApp(
      theme: ThemeData(
        shadowColor: SHADOW_BLUE,
        fontFamily: 'SQUAREAIR'
      ),

      home: MapScreen(),
    ),
  );
}
