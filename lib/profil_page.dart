import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/my_home_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Detail_page.dart';
import 'package:image_picker/image_picker.dart';
import 'insertCollabo_page.dart';
import 'ListeCollaboPage.dart';
import 'header.dart';
import 'car_temp.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'package:flutter_application_1/map_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key ?? const Key('default_key'));

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isSwitched = false;
  String? collaborateurId;
  double? latitude;
  double? longitude;
  bool locationFetchSuccess = false;
  bool isButtonOn = false;

  @override
  void initState() {
    super.initState();
    _loadCollaborateurId();
  }

  Future<void> _loadCollaborateurId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      collaborateurId = prefs.getString('collaborateurId');
    });
    _fetchPickupLocation(collaborateurId);
  }

  Future<void> _fetchPickupLocation(String? collaborateurId) async {
    if (collaborateurId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.163.13.69:8080/pickup/$collaborateurId'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> locations = jsonDecode(response.body);
          if (locations.isNotEmpty) {
            setState(() {
              latitude = double.parse(locations[0]['latitude']);
              longitude = double.parse(locations[0]['longitude']);
              locationFetchSuccess = true; // Marquer la réussite
            });
            // Afficher les valeurs de latitude et longitude dans la console
            print('Latitude: $latitude, Longitude: $longitude');
          }
        } else {
          throw Exception('Failed to load pickup location');
        }
      } catch (e) {
        print('Error fetching pickup location: $e');
        locationFetchSuccess = false; // Marquer l'échec
      }
    }
  }

  void _updatePresenceStatus(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('presenceToday', newValue);
    setState(() {
      isButtonOn = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _textColor = Color.fromARGB(255, 85, 85, 85);

    return Scaffold(
      appBar: Header(
        title: "Profil",
        onSearchTextChanged: (text) {}
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text('Geolocation-Pulse-Shuttle', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            const Divider(
              color: Color.fromARGB(255, 206, 204, 204),
              thickness: 1,
            ),
            ListTile(
              title: const Text('Profil', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.person),
              iconColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              title: const Text('Inscription', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.person_add),
              iconColor: Colors.grey,
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
              iconColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailsPage()));
              },
            ),
            ListTile(
              title: const Text('insertion d_un Collaborateur', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.person_add),
              iconColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertCollaboPage()));
              },
            ),
            ListTile(
              title: const Text('liste des collaborateurs', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.list),
              iconColor: Colors.grey,
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
              iconColor: Colors.grey,
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
              title: const Text('Paramètre', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.settings),
              iconColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailsPage()));
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 206, 204, 204),
              thickness: 1,
            ),
            ListTile(
              title: const Text('Map', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.map),
              iconColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FutureBuilder<Map<String, String>>(
          future: _getSavedData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
            } else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Présence Aujourd''hui: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: const TextStyle(fontSize: 16, color: _textColor),
                        ),
                        const SizedBox(width: 30.0),
                        Text(
                          'Off',
                          style: TextStyle(color: isSwitched ? Colors.grey : Colors.red),
                        ),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              _updatePresenceStatus(value);
                            });
                          },
                          activeTrackColor: Colors.green,
                          inactiveTrackColor: Colors.grey,
                          activeColor: const Color.fromARGB(255, 189, 187, 187),
                        ),
                        Text(
                          'On',
                          style: TextStyle(color: isSwitched ? Colors.green : Colors.grey),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    if (isSwitched && locationFetchSuccess) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            const Text(
                              'Point de ramassage:',
                              style: const TextStyle(fontSize: 16, color: _textColor),
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              '(Latitude: ${latitude ?? ''} , Longitude: ${longitude ?? ''})',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ],
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/pdp1.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () {
                              _selectImageFromGallery(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Nom:',
                          style: TextStyle(fontSize: 14, color: _textColor),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${snapshot.data?['nom'] ?? ''}',
                          style: const TextStyle(fontSize: 14, color: _textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Prénom:',
                          style: TextStyle(fontSize: 14, color: _textColor),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${snapshot.data?['prenom'] ?? ''}',
                          style: const TextStyle(fontSize: 14, color: _textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Matricule:',
                          style: TextStyle(fontSize: 14, color: _textColor),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${snapshot.data?['matricule'] ?? ''}',
                          style: const TextStyle(fontSize: 14, color: _textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Pôle:',
                          style: TextStyle(fontSize: 14, color: _textColor),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${snapshot.data?['pole'] ?? ''}',
                          style: const TextStyle(fontSize: 14, color: _textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Axe:',
                          style: TextStyle(fontSize: 14, color: _textColor),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${snapshot.data?['axe'] ?? ''}',
                          style: const TextStyle(fontSize: 14, color: _textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chef de car :',
                          style: TextStyle(fontSize: 14, color: _textColor),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${snapshot.data?['chefdecar'] ?? ''}',
                          style: const TextStyle(fontSize: 14, color: _textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    QrImage(
                      data: _generateQRData(snapshot.data),
                      version: QrVersions.auto,
                      size: 200,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailsPage()),
          );
        },
        child: const Icon(Icons.navigate_next),
      ),
    );
  }

  String _generateQRData(Map<String, String>? data) {
    if (data != null) {
      return 'Nom: ${data['nom']}\nPrénom: ${data['prenom']}\nMatricule: ${data['matricule']}';
    } else {
      return '';
    }
  }

  Future<Map<String, String>> _getSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'nom': prefs.getString('nom') ?? '',
      'prenom': prefs.getString('prenom') ?? '',
      'matricule': prefs.getString('matricule') ?? '',
      'pole': prefs.getString('pole') ?? '',
      'axe': prefs.getString('axe') ?? '',
      'chefdecar': prefs.getString('chefdecar') ?? '',
    };
  }

  Future<void> _selectImageFromGallery(BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImageUrl', pickedImage.path);
    }
  }
}
