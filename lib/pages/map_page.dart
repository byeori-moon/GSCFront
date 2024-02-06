import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final Position currentPosition;

  const MapPage({Key? key, required this.currentPosition}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng = LatLng(
      widget.currentPosition.latitude,
      widget.currentPosition.longitude,
    );

    return Scaffold(
      backgroundColor: Color(0xFFF7DAD2),
      body: Center(
        child: SizedBox(
          height: 400,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            child:
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLatLng,
                zoom: 10,
              ),
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _updateMap();
          _printLocation();
        },
        label: const Text('Refresh Map'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  void _updateMap() {
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            widget.currentPosition.latitude,
            widget.currentPosition.longitude,
          ),
        ),
      );
    }
  }

  void _printLocation() {
    print('Current Latitude: ${widget.currentPosition.latitude}');
    print('Current Longitude: ${widget.currentPosition.longitude}');
  }
}
