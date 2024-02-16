import 'package:camera_pj/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/space_controller.dart';
import '../controller/space_object_controller.dart';


class SpaceDetailScreen extends StatelessWidget {
  final Space space;
  SpaceDetailScreen({Key? key, required this.space}) : super(key: key);
  final SpaceObjectController controller = Get.put(SpaceObjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        title: Text(space.spaceName),
        backgroundColor: BACKGROUND_COLOR,
      ),
      body: Obx(() => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemCount: controller.spaceDetails.length,
        itemBuilder: (context, index) {
          SpaceDetail spaceDetail = controller.spaceDetails[index];
          return Card(
            color: DEFAULT_YELLOW,
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Image.network(spaceDetail.thumbnailImage),
                Text(spaceDetail.nickname),
              ],
            ),
          );
        },
      )),
    );
  }
}
