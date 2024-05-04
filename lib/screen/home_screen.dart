import 'package:camera_pj/component/input_component.dart';
import 'package:camera_pj/constant/colors.dart';
import 'package:camera_pj/controller/account_controller.dart';
import 'package:camera_pj/controller/object_controller.dart';
import 'package:camera_pj/screen/before_camera_screen.dart';
import 'package:camera_pj/screen/camera_screen.dart';
import 'package:camera_pj/screen/map_screen.dart';
import 'package:camera_pj/screen/quiz_main_screen.dart';
import 'package:camera_pj/screen/search_place_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../component/sign_in_component.dart';
import '../controller/space_controller.dart';

class HomeScreen extends StatefulWidget {
  final int? initialIndex;

  const HomeScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  final List<Widget> _widgetOptions = <Widget>[
    _HomeScreen(),
    MapScreen(),
    QuizMainScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.house_outlined), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined), label: 'map'),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_support), label: 'quiz'),
          ],
          selectedItemColor: BUTTON_BLUE,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
        ),
      ),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
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

class _BottomBar extends StatefulWidget {
  const _BottomBar({super.key});

  @override
  State<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<_BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: BUTTON_BLUE.withOpacity(0.25),
            blurRadius: 4.0,
            offset: Offset(0, -1),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: BUTTON_BLUE,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.home_outlined, color: BACKGROUND_COLOR),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person_outline, color: BUTTON_BLUE),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined, color: BUTTON_BLUE),
          ),
        ],
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SpaceController spaceController = Get.find();
    final AccountController accountController = Get.find();
    final ObjectController objectController = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Create a new place!",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: BUTTON_BLUE,
              fontFamily: 'OHSQUARE',
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: GestureDetector(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: BACKGROUND_SECOND_COLOR,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Search your address",
                    style: TextStyle(
                      color: BUTTON_BLUE,
                      fontFamily: 'OHSQUAREAIR',
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              onTap: () {
                Get.to(SearchPlaceScreen());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Check on Map",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: BUTTON_BLUE,
                fontFamily: 'OHSQUARE',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: DEFAULT_YELLOW,
                    width: 6,
                  ),
                ),
                child: MapScreen(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              height: 95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(BeforeDartCamera());
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: SHADOW_BLUE,
                        foregroundColor: Colors.black.withOpacity(0.8),
                        backgroundColor: MAINSCREEN_COLOR,
                        elevation: 3,
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/img/camera_penguin.png',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Text(
                            'Capture',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OHSQUAREAIR',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        spaceController.showMySpacesModal(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: SHADOW_BLUE,
                        foregroundColor: Colors.black.withOpacity(0.8),
                        backgroundColor: MAINSCREEN_COLOR,
                        elevation: 3,
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/img/flag_penguin.png',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Text(
                            'Place List',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OHSQUAREAIR',
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
