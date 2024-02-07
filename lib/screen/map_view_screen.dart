import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../controller/address_controller.dart';
import 'save_my_place_screen.dart';
import 'package:dio/dio.dart';

class MapViewScreen extends StatefulWidget {
  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final AddressController addressController = Get.put(AddressController());
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio();
  final String _apiKey = '';
  List<dynamic> _autocompletePlaces = [];
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;
  final Set<Marker> _markers = {};
  final FocusNode _focusNode = FocusNode();
  bool _showMap = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showMap = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNode를 dispose 해줍니다.
    super.dispose();
  }


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _searchPlaces(String searchText) async {
    if (searchText.isEmpty) {
      setState(() {
        _autocompletePlaces = [];
        _markers.clear();
      });
      return;
    }

    final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchText&types=geocode&key=$_apiKey';

    try {
      final response = await _dio.get(url);
      setState(() {
        _autocompletePlaces = response.data['predictions'].take(5).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  void _selectPlace(String placeId, String description) async {
    FocusScope.of(context).unfocus();
    _controller.text = description;

    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,geometry&key=$_apiKey';

    try {
      final response = await _dio.get(url);
      final data = response.data['result']['geometry']['location'];
      final LatLng position = LatLng(data['lat'], data['lng']);
      setState(() {
        _selectedPosition = position;
        _markers.clear();
        _markers.add(Marker(
          markerId: MarkerId(placeId),
          position: position,
        ));
        _autocompletePlaces = [];
        _showMap = true;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search Place',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _searchPlaces,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _autocompletePlaces.length,
              itemBuilder: (context, index) {
                final item = _autocompletePlaces[index];
                return ListTile(
                  title: Text(item['description']),
                  onTap: () => _selectPlace(item['place_id'], item['description']),
                );
              },
            ),
          ),
          if (_selectedPosition != null && _showMap)
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _selectedPosition!,
                  zoom: 15,
                ),
                markers: _markers,
              ),
            ),
          if (_selectedPosition != null && _showMap)
            ElevatedButton(
              onPressed: () {
                final AddressController addressController = Get.find();
                addressController.updatePlace('', _controller.text, _selectedPosition!.latitude, _selectedPosition!.longitude);
                Get.to(() => SaveMyPlaceScreen());
              },
              child: Text('이 위치로 선택하기'),
            ),
        ],
      ),
    );
  }
}
