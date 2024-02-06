import 'package:camera_pj/pages/camera.dart';
import 'package:camera_pj/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF7DAD2),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;

    double targetWidth = screenWidth * 0.8;
    double targetHeigth = screenHeigth * 0.4;
    double buttonWidth = targetWidth * 0.45; // 버튼 폭 계산
    double buttonHeigth = targetHeigth * 0.5; // 버튼 폭 계산

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: targetWidth,
              child: Text("지번, 도로명, 건물명으로 검색"),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
            Container(
              width: targetWidth,
              child: Text("지도에서 장소 확인하기"),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Container(
              width: targetWidth,
              height: targetHeigth,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20.0), // border radius 설정
              ),
              child: FutureBuilder<Position>(
                future: _getCurrentLocation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    // Use the current location data to pass it to MapPage or any other widget
                    print('L:Latitude: ${snapshot.data!.latitude}');
                    print('L:Longitude: ${snapshot.data!.longitude}');
                    // Returning MapPage directly here
                    return MapPage(currentPosition: snapshot.data!);
                  } else {
                    return Center(
                      child: Text('Unable to get location'),
                    );
                  }
                },
              ),
            ),

            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,5.0,0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraApp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(buttonWidth, buttonHeigth), // 버튼 크기 지정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // 원하는 radius 값으로 변경
                      ),
                    ),
                    child: Text('Button 1'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0,0,0,0), // 좌우 패딩 5.0 추가
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle the second button press
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(buttonWidth, buttonHeigth), // 버튼 크기 지정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // 원하는 radius 값으로 변경
                      ),
                    ),
                    child: Text('Button 2'),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    } else if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied forever");
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      throw Exception("Error getting current location: $e");
    }
  }

}
