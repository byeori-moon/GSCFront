import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/space_controller.dart';


class SpaceDetailScreen extends StatelessWidget {
  final Space space;

  const SpaceDetailScreen({Key? key, required this.space}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(space.spaceName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("ID: ${space.id}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Firebase UID: ${space.firebaseUID}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Category: ${space.category}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Name: ${space.spaceName}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Coordinates: ${space.coordinates}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
