import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../screen/home_screen.dart';
import '../screen/map_screen.dart';

class BottomButtonBar extends StatelessWidget {
  const BottomButtonBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        switch (index) {
          case 0:
            Get.to(HomeScreen());
            break;
          case 1:
            Get.to(MapScreen());
            break;
          case 2:
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.house_outlined),label: 'home'),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined),label: 'map'),
        BottomNavigationBarItem(icon: Icon(Icons.contact_support),label: 'quiz'),
      ],
      selectedItemColor: BUTTON_BLUE,
      showUnselectedLabels: false,
    );
  }
}
