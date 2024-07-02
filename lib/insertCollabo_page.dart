import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ListeCollaboPage.dart';
import 'detail_page.dart';
import 'my_home_page.dart';
import 'profil_page.dart';
import 'header.dart';
import 'car_temp.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter_application_1/map_page.dart';
import 'package:flutter_application_1/Autehtification.dart';




    

class InsertCollaboPage extends StatefulWidget {
  const InsertCollaboPage({Key? key}) : super(key: key ?? const Key('default_key'));


  @override
  State<InsertCollaboPage> createState() => _InsertCollaboPageState();
}



class _InsertCollaboPageState extends State<InsertCollaboPage> {
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
        title: "insertion Collaborateur",      
       
        onSearchTextChanged: (text) {
        }
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
                        color:Color.fromARGB(255, 206, 204, 204), 
                        thickness: 1, 
            ),
            ListTile(
              title: const Text('Profil', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0 )),
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
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title:"flutter démo", collaborateurId: "id")));
                
              },
            ),
            const Divider( 
                        color:Color.fromARGB(255, 206, 204, 204), 
                        thickness: 1, 
            ),
            ListTile(
              title:const Text(' Pour Chef de Car', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
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
             onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder:(context) => const InsertCollaboPage()));
             },
            ),
            ListTile(
              title:const Text('liste des collaborateurs' , style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)) ,
              leading:  const Icon(Icons.list),
              iconColor: Colors.red,
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ListeCollaboPage()));
              },
            ),
            const Divider( 
                        color:Color.fromARGB(255, 206, 204, 204), 
                        thickness: 1, 
            ),
            ListTile(
              title: const Text('Demande Car Temporaire', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85) , fontSize: 12.0)) ,
              leading: const Icon(Icons.mail) ,
              iconColor: Colors.red,
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder:(context) =>const  CarTempPage()));
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Image.asset(
                      'assets/liste.png',
                      height: 100,
                      width: 100,
                    ),
            const SizedBox(height: 20),
            const Text('INSERTION DE COLLABORATEUR'  , style:  TextStyle(color: Colors.red),),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  nom = value;
                });
              },
              decoration:const InputDecoration(
                hintText: 'Insert First_Name',
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  prenom = value;
                });
              },
              decoration:const  InputDecoration(
                hintText: 'Insert Last_Name',
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  matricule = value;
                });
              },
              decoration:const  InputDecoration(
                hintText: 'Insert identification number',
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  mobile = value;
                });
              },
              decoration:const  InputDecoration(
                hintText: 'Insert Mobile Number',
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  pole = value;
                });
              },
              decoration:const  InputDecoration(
                hintText: 'Insert Department',
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  axe = value;
                });
              },
              decoration:const  InputDecoration(
                hintText: 'Insert Location',
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  chefdecar = value;
                });
              },
              decoration:  const InputDecoration(
                hintText: ' Bus Supervisor or not  ',
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            const SizedBox(height: 15.0),
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
            MaterialPageRoute(builder: (context) =>  ListeCollaboPage()),
          );
        },
        child: const Icon(Icons.list),
      ),
    );
  }

  Future<void> _generateQRCode(String value) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code',style: TextStyle(color: Color(0xFF311D64))),
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
              child: const Text('Close', style: TextStyle(color: Color(0xFFE53520)),),
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
  List<String> collaborateurs = prefs.getStringList('collaborateurs') ?? [];

  collaborateurs.add('$nom $prenom $matricule');
  prefs.setStringList('collaborateurs', collaborateurs);
  Navigator.of(context).pop();
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ListeCollaboPage()),
  );
}

}
