import 'package:camera_pj/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/space_controller.dart';
import '../controller/space_object_controller.dart';


class SpaceDetailScreen extends StatelessWidget {
  final Space space;
  SpaceDetailScreen({Key? key, required this.space}) : super(key: key);
  final SpaceObjectController spaceObjectController = Get.put(SpaceObjectController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        title: Text(space.spaceName),
        backgroundColor: BACKGROUND_COLOR,
      ),
      body: Obx(() => Container(
        child: FutureBuilder<List<SpaceDetail>>(
            future: spaceObjectController.fetchSpaceObjects(space.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: spaceObjectController.spaceDetails.length,
              itemBuilder: (context, index) {
                SpaceDetail spaceDetail = spaceObjectController.spaceDetails[index];
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
            );
          }
        ),
      )),
    );
  }
}
