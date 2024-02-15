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
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng userCurrentLocation = LatLng(position.latitude, position.longitude);
    print(position);
    setState(() {
      initialPosition = userCurrentLocation;
    });

    // mapController가 설정되었다면 카메라 위치 업데이트
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: userCurrentLocation,
            zoom: 14.0,
          ),
        ),
      ).then((_) {
        // 마커를 가져와서 모든 마커를 포함하도록 카메라 조정
        Set<Marker> markers = spaceController.getMarkers(context);
        _updateCameraPosition(markers, mapController!);
      });
    }
  }
  void _updateCameraPosition(Set<Marker> markers, GoogleMapController mapController) {
    if (markers.isNotEmpty) {
      var southWest = LatLng(markers.first.position.latitude, markers.first.position.longitude);
      var northEast = LatLng(markers.first.position.latitude, markers.first.position.longitude);

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

      // 경계를 사용하여 카메라 업데이트
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(southwest: southWest, northeast: northEast),
          50.0, // 경계와 화면 사이의 패딩
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
          _getUserLocation(); // 사용자 위치를 가져오고 마커들을 포함하도록 카메라 조정
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
