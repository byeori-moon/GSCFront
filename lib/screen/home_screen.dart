import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'map_view_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //String apiKey = dotenv.env['GOOGLE_PlACES_API'] ?? "";
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  '새롭게 내 장소를 등록해주세요!',
                  textAlign: TextAlign.start,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => MapViewScreen());
                  },
                  child: Text('주소 검색'),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '지도에서 장소 확인하기',
                  textAlign: TextAlign.start,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
