import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/space_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final SpaceController spaceController = Get.find();
  GoogleMapController? mapController;
  LatLng initialPosition = LatLng(34.0, 34.0);

  Future<void> _getUserLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng userCurrentLocation = LatLng(position.latitude, position.longitude);
    print(position);
    setState(() {
      initialPosition = userCurrentLocation;
    });

    if (mapController != null) {
      mapController!
          .animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: userCurrentLocation,
            zoom: 14.0,
          ),
        ),
      )
          .then((_) {
        Set<Marker> markers = spaceController.getMarkers(context);
        _updateCameraPosition(markers, mapController!);
      });
    }
  }

  void _updateCameraPosition(
      Set<Marker> markers, GoogleMapController mapController) {
    if (markers.isNotEmpty) {
      var southWest = LatLng(
          markers.first.position.latitude, markers.first.position.longitude);
      var northEast = LatLng(
          markers.first.position.latitude, markers.first.position.longitude);

      for (var marker in markers) {
        if (marker.position.latitude < southWest.latitude) {
          southWest = LatLng(marker.position.latitude, southWest.longitude);
        }
        if (marker.position.longitude < southWest.longitude) {
          southWest = LatLng(southWest.latitude, marker.position.longitude);
        }
        if (marker.position.latitude > northEast.latitude) {
          northEast = LatLng(marker.position.latitude, northEast.longitude);
        }
        if (marker.position.longitude > northEast.longitude) {
          northEast = LatLng(northEast.latitude, marker.position.longitude);
        }
      }

      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(southwest: southWest, northeast: northEast),
          50.0,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = spaceController.getMarkers(context);

    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
          });
          _getUserLocation();
        },
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 14.0,
        ),
        markers: markers,
      ),
    );
  }
}
