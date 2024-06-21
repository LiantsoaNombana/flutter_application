import 'package:flutter/material.dart';
import 'package:flutter_application_1/carte_page.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ListeCollaboPage.dart';
import 'profil_page.dart';
import 'insertCollabo_page.dart';
import 'my_home_page.dart';
import 'header.dart';
import 'car_temp.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: "Chef de car", 
        
        onSearchTextChanged: (text) {
        }
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
                        color:Color.fromARGB(255, 206, 204, 204), 
                        thickness: 1, 
            ),
            ListTile(
              title: const Text('Profil', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0 )),
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
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title:"flutter démo" , collaborateurId: "id")));
                
              },
            ),
            const Divider( 
                        color:Color.fromARGB(255, 206, 204, 204), 
                        thickness: 1, 
            ),
            ListTile(
              title:const Text(' Pour Chef de Car', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
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
             onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder:(context) => const InsertCollaboPage()));
             },
            ),
            ListTile(
              title:const Text('liste des collaborateurs' , style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)) ,
              leading:  const Icon(Icons.list),
              iconColor: Colors.grey,
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
              title: const Text('Demande Car Temporaire ', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85) , fontSize: 12.0)) ,
              leading: const Icon(Icons.mail) ,
              iconColor: Colors.grey,
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder:(context) =>const  CarTempPage()));
              }
            ),
            ListTile(
              title: const Text("Carte" , style: TextStyle(color: Color.fromARGB(255, 85, 85, 85) , fontSize: 12.0)),
              leading: const Icon(Icons.map),
              iconColor: Colors.grey,
              onTap:(){
                Navigator.pop(context);
                Navigator.push(context , MaterialPageRoute(builder: (context ) => const CartePage(latitude: 47.5338, longitude: 47.5338)));
              }
            ),
            const Divider( 
                        color:Color.fromARGB(255, 206, 204, 204), 
                        thickness: 1, 
            ),
            ListTile(
              title: const Text('Paramètre', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)),
              leading: const Icon(Icons.settings),
              iconColor: Colors.grey,
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailsPage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Pour les chefs de car'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _scanQR(context);
              },
              style: ElevatedButton.styleFrom(
                      backgroundColor:const Color(0xFF311D64), 
                    ),
              child: const Text('Scanner un code QR', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Accueil' , collaborateurId: 'id')),
            (route) => false, // Supprime toutes les routes actuelles dans la pile de navigation
          );
        },
        child: const Icon(Icons.navigate_before),
      ),
    );
  }

  Future<void> _scanQR(BuildContext context) async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        String qrResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Annuler', true, ScanMode.QR);
        if (qrResult != "-1") {
          Navigator.pop(context, qrResult);
        }
      } catch (e) {
        print(e.toString());
      }
    } else if (status.isDenied) {
      print('Permission refusée pour accéder à la caméra.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission nécessaire'),
            content: const Text(
              'Pour utiliser cette fonctionnalité, veuillez autoriser l\'accès à la caméra dans les paramètres de l\'application.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer', style: TextStyle(color: Color(0xFFE53520))),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                },
                child: const Text('Paramètres', style: TextStyle(color: Color(0xFFE53520))),
              ),
            ],
          );
        },
      );
    }
  }
}