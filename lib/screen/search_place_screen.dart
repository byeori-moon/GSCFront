import 'package:camera_pj/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import '../controller/address_controller.dart';
import 'save_my_place_screen.dart';
import 'package:dio/dio.dart';

class SearchPlaceScreen extends StatefulWidget {

  @override
  _SearchPlaceScreenState createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  final AddressController addressController = Get.put(AddressController());
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio();
  final String? _apiKey = dotenv.env['MAP_KEY'];
  List<dynamic> _autocompletePlaces = [];
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;
  final Set<Marker> _markers = {};
  final FocusNode _focusNode = FocusNode();
  bool _showMap = true;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showMap = false;
          _controller.clear();
          _autocompletePlaces.clear();
          _selectedPosition = null;
        });
      }
    });
  }

  void _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _selectedPosition =
          LatLng(_locationData.latitude ?? 0.0, _locationData.longitude ?? 0.0);
      _markers.add(Marker(
        markerId: MarkerId("current_location"),
        position: _selectedPosition!,
      ));
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
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

    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchText&types=geocode&key=$_apiKey';

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

    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,geometry&key=$_apiKey';

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
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        title: Text(
          'Register My Location',
          style: TextStyle(fontFamily: 'OHSQUAREAIR'),
        ),
        backgroundColor: BACKGROUND_COLOR,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: BACKGROUND_SECOND_COLOR,
                borderRadius: BorderRadius.circular(999),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Search My Location',
                  labelStyle: TextStyle(fontFamily: 'OHSQUAREAIR'),
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onChanged: _searchPlaces,
              ),
            ),
          ),
          if (_autocompletePlaces.isNotEmpty)
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
          if (_selectedPosition != null && _showMap&&_autocompletePlaces.isEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _selectedPosition ?? LatLng(37.5665, 126.9780),
                    zoom: 15,
                  ),
                  markers: _markers,
                ),
              ),
            ),
          if (_selectedPosition != null && _showMap)
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: BUTTON_BLUE,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                        side: BorderSide(
                          color: BUTTON_BLUE,
                          width: 1,
                        )),
                  ),
                  onPressed: () {
                    final AddressController addressController = Get.find();
                    addressController.updatePlace(
                        '',
                        _controller.text,
                        _selectedPosition!.latitude,
                        _selectedPosition!.longitude);
                    Get.to(() => SaveMyPlaceScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                          size: 20,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Select',
                        style: TextStyle(
                          fontFamily: 'OHSQUARE',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
