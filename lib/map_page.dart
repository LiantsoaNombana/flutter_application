import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'my_home_page.dart';
import 'Detail_page.dart';
import 'insertCollabo_page.dart';
import 'ListeCollaboPage.dart';
import 'header.dart';
import 'car_temp.dart';
import 'profil_page.dart';
import 'package:flutter_application_1/Autehtification.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  final MapController _mapController = MapController();
  static const LatLng _pPulseLocation = LatLng(-18.848466873168945, 47.480770111083984);
  static const LatLng _pHomeLocation = LatLng(-18.847962, 47.553804);
  static const LatLng _pOneLocation = LatLng(-18.8334830, 47.5638413);
  static const LatLng _pTwoLocation = LatLng(-18.8361547, 47.5558164);
  static const LatLng _pThreeLocation = LatLng(-18.8549459, 47.5536130);
  static const LatLng _pFourLocation = LatLng(-18.8660637, 47.5514183);
  static const LatLng _pFiveLocation = LatLng(-18.8727009, 47.5485294);
  static const LatLng _pSixLocation = LatLng(-18.8701249, 47.5213361);
  static const LatLng _pSevenLocation = LatLng(-18.8685775, 47.5156847);
  static const LatLng _pEightLocation = LatLng(-18.8714943, 47.4952366);
  LatLng? _currentP;

  List<Polyline> polylines = [];

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: "Geolocation",
        onSearchTextChanged: (text) {}
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color:   Color.fromARGB(255, 243, 49, 35),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/pulse.png',
                      height: 70,
                      width: 70,
                    ),
                    const SizedBox(height: 10), // Espace entre le texte et l'image
                    const Text(
                      'Geolocation-Pulse-Shuttle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(
              color: Color.fromARGB(255, 206, 204, 204),
              thickness: 1,
            ),
            ListTile(
              title: const Text('Profil', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.person),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              title: const Text('Inscription', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.person_add),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "flutter démo", collaborateurId: "id")));
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 206, 204, 204),
              thickness: 1,
            ),
            ListTile(
              title: const Text('Chef de car ', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.qr_code_scanner),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailsPage()));
              },
            ),
            ListTile(
              title: const Text('insertion d_un Collaborateur', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.person_add),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertCollaboPage()));
              },
            ),
            ListTile(
              title: const Text('liste des collaborateurs', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.list),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListeCollaboPage()));
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 206, 204, 204),
              thickness: 1,
            ),
            ListTile(
              title: const Text('Demande Car Temporaire', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.mail),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CarTempPage()));
              }
            ),
            const Divider(
              color: Color.fromARGB(255, 206, 204, 204),
              thickness: 1,
            ),
            ListTile(
              title: const Text('Map', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.map),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage()));
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 206, 204, 204),
              thickness: 1,
            ),
            ListTile(
              title: const Text('Paramètre', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.settings),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              title: const Text('Deconnexion', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.logout),
              iconColor: Colors.red,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('collaboratorId');
                if (!mounted) return;
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthenticationPage()));
              },
            ),
          ],
        ),
      ),
      body: _currentP == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              options: const MapOptions(
                initialCenter: _pPulseLocation,
                initialZoom: 15.0,
              ),
              mapController: _mapController,
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentP!,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pPulseLocation,
                      child: Icon(
                        Icons.place,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pHomeLocation,
                      child: Icon(
                        Icons.home,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pOneLocation,
                      child: Icon(
                        Icons.place,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pTwoLocation,
                      child: Icon(
                        Icons.place,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pThreeLocation,
                      child: Icon(
                        Icons.place,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pFourLocation,
                      child: Icon(
                        Icons.place,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pFiveLocation,
                      child: Icon(
                        Icons.place,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pSixLocation,
                      child: Icon(
                        Icons.place,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pSevenLocation,
                      child: Icon(
                        Icons.place,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                    const Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pEightLocation,
                      child: Icon(
                        Icons.place,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: polylines,
                ),
              ],
            ),
    );
  }

Future<void> _cameraPosition(LatLng pos) async {
  double zoomLevel = 15.0; 
  _mapController.move(pos, zoomLevel);
}



  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraPosition(_currentP!);
        });
      }
    });
  }
}
