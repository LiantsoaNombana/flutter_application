import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/ListeCollaboPage.dart';
import 'package:flutter_application_1/car_temp.dart';
import 'package:flutter_application_1/map_page.dart';
import 'package:flutter_application_1/insertCollabo_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profil_page.dart';
import 'detail_page.dart';
import 'header.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'Autehtification.dart';



class MyHomePage extends StatefulWidget {
  final String title;
  final String collaborateurId; // Ajoutez cette ligne

  const MyHomePage({Key? key, required this.title, required this.collaborateurId}) : super(key: key ?? const Key('default_key'));

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String nom = "";
  String prenom = "";
  String matricule = "";
  String mobile = "";
  String pole = "";
  String axe = "";
  String chefdecar = "";
  List<String> collaborateurs = [];
  List<String> filteredCollaborateurs = [];
  bool isVerified = false; // Ajoutez cette variable pour vérifier l'état de la vérification

  Future<void> _verifyCollaborator() async {
    const String apiUrl = 'http://10.163.13.69:8080/collaborateur/verifyCollaborator';

    try {
      print('Sending request to $apiUrl');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'matricule': matricule,
          'mobile': mobile,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          isVerified = true;
        });
        Fluttertoast.showToast(msg: 'Collaborator Verified - OK');
      } else {
        Fluttertoast.showToast(msg: 'Collaborator Not Found - Invalid');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'Error connecting to server');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: "Accueil",
        onSearchTextChanged: (text) {},
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
                      'assets/test.png',
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
              title: const Text('Authentification', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.person),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthenticationPage()));
              },
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "flutter démo" ,collaborateurId: "id")));
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 206, 204, 204),
              thickness: 1,
            ),
            ListTile(
              title: const Text('Pour Chef de Car', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
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
              title: const Text('Demande Car temporaire', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.mail),
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CarTempPage()));
              },
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/icone.png'),
            ),
            const SizedBox(height: 30.0),
            const Text('CREATION DU PROFIL', style: TextStyle(color: Color(0xFF311D64))),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    nom = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Insert your Firstname',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 252, 252),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    prenom = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Insert your lastName',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 252, 252),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    matricule = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Insert your identification Number',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 252, 252),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    mobile = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'insert your number\'s phone',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 252, 252),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    pole = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'insert your departement',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 252, 252, 252),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    axe = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'insert your location',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 252, 252),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    chefdecar = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Are you a bus supervisor',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 252, 252),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _verifyCollaborator,
              child: const Text('Verify the employee'),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: isVerified
                  ? () {
                      if (nom.isNotEmpty &&
                          prenom.isNotEmpty &&
                          matricule.isNotEmpty &&
                          pole.isNotEmpty &&
                          axe.isNotEmpty) {
                        String data = 'Nom: $nom\nPrénom: $prenom\nMatricule: $matricule';
                        _generateQRCode(data);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Please enter a value before generating the QR code'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close', style: TextStyle(color: Color(0xFFE53520))),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isVerified ? const Color(0xFF311D64) : Colors.grey,
              ),
              child: const Text('QR Code', style: TextStyle(color: Colors.white)),
            ),
          ],
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

  Future<void> _generateQRCode(String value) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImage(
                  data: value,
                  version: QrVersions.auto,
                  size: MediaQuery.of(context).size.width * 0.6,
                ),
                const SizedBox(height: 10.0),
                Text('Nom:  $nom'),
                Text('Prénom(s): $prenom'),
                Text('Matricule: $matricule'),
                Text('Pole: $pole'),
                Text('Axe: $axe'),
                Text('Chef de car: $chefdecar'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Color(0xFFE53520))),
            ),
            TextButton(
              onPressed: () {
                _saveDataAndNavigateToProfilePage();
              },
              child: const Text('Save', style: TextStyle(color: Color(0xFFE53520))),
            ),
          ],
        );
      },
    );
  }

  void _saveDataAndNavigateToProfilePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nom', nom);
    prefs.setString('prenom', prenom);
    prefs.setString('matricule', matricule);
    prefs.setString('pole', pole);
    prefs.setString('axe', axe);
    prefs.setString('chefdecar', chefdecar);

    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }
}
