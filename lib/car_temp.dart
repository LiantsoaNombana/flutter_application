import 'package:flutter/material.dart';
import 'package:flutter_application_1/Autehtification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_page.dart';
import 'header.dart';
import 'insertCollabo_page.dart';
import 'ListeCollaboPage.dart';
import 'my_home_page.dart';
import 'profil_page.dart';
import 'carte_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/map_page.dart';

enum AxisSelection { itaosy, ambohimangakely, ivato }

class Collaborateur {
  final int id;
  final String nom;
  final String prenom;

  Collaborateur({
    required this.id,
    required this.nom,
    required this.prenom,
  });

  factory Collaborateur.fromJson(Map<String, dynamic> json) => Collaborateur(
        id: json['id'] as int,
        nom: json['nom'] as String,
        prenom: json['prenom'] as String,
      );
}
class Car {
  final String matricule;
  final int numberPlace;
  final int axeId;
  final String axeName;
  bool isChecked;

  Car({
    required this.matricule,
    required this.numberPlace,
    required this.axeId,
    required this.axeName,
    this.isChecked = false,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      matricule: json['matricule'],
      numberPlace: json['number_place'],
      axeId: json['axe']['id'],
      axeName: json['axe']['name'],
    );
  }
}



class CarTempPage extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? pointName;

  const CarTempPage({Key? key, this.latitude, this.longitude, this.pointName}) : super(key: key);

  @override
  _CarTempPageState createState() => _CarTempPageState();
}

class _CarTempPageState extends State<CarTempPage> {
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  AxisSelection selectedAxis = AxisSelection.itaosy;
  String? collaborateurId; 
  List<Car> cars =[];

  @override
  void initState() {
    super.initState();
    _loadCollaborateurId();
    fetchCars();
  }
  
  Future<void> _loadCollaborateurId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      collaborateurId = prefs.getString('collaborateurId');
    });
    _sendData();
  }
  Future<void> fetchCars() async {
  final response = await http.get(Uri.parse('http://10.163.13.69:8080/car'));

  if (response.statusCode == 200) {
    List<dynamic> responseData = jsonDecode(response.body);
    print('Response Data: $responseData'); // Ajoutez cette ligne pour vérifier les données de réponse
    setState(() {
      cars = responseData.map((data) => Car.fromJson(data)).toList();
    });
  } else {
    throw Exception('Failed to load cars');
  }
}

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate! : endDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _sendData() async {
    if (collaborateurId == null) {
      print('Collaborator ID is null');
      return;
    }

    final pickupTemp = {
      'collaborateur': collaborateurId,
      'date_created': startDate!.toIso8601String().substring(0, 10),
      'date_finished': endDate!.toIso8601String().substring(0 ,10),
      'longitude': widget.longitude!.toStringAsFixed(6),
      'latitude': widget.latitude!.toStringAsFixed(6),
    };

    print('Sending data: $pickupTemp'); 

    try {
      final response = await http.post(
        Uri.parse('http://10.163.13.69:8080/pickup_temp/ajoutPickupTemp'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(pickupTemp),
      );

      print('Response status: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pickup temp ajouté avec succès')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du pickup temp: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e) {
      print('Error: $e'); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de communication avec le serveur: $e')),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: "Demande Car temporaire",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Date de début :',
                style: TextStyle(color: Color(0xFF311D64)),
              ),
              const SizedBox(height: 10),
              Text(
                '${startDate?.day}/${startDate?.month}/${startDate?.year}',
                style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 141, 141, 141)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: const Text('Sélectionner la date de début', style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Color.fromARGB(255, 211, 210, 210),
                thickness: 1,
              ),
              const SizedBox(height: 20),
              const Text(
                'Date de fin :',
                style: TextStyle(color: Color(0xFF311D64)),
              ),
              const SizedBox(height: 10),
              Text(
                '${endDate?.day}/${endDate?.month}/${endDate?.year}',
                style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 141, 141, 141)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: const Text('Sélectionner la date de fin', style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Color.fromARGB(255, 211, 210, 210),
                thickness: 1,
              ),
              const SizedBox(height: 20),
              const Text(
                'Sélectionnez un axe :',
                style: TextStyle(color: Color(0xFF311D64)),
              ),  
          
            const SizedBox(height: 10),
            
            for (var car in cars)
              CheckboxListTile(
                title: Text('Axe: ${car.axeName}' , style: const TextStyle(color: Color.fromARGB(255, 141, 141, 141))),
                subtitle: Text('Matricule: ${car.matricule}' , style: const TextStyle(color:  Color.fromARGB(255, 141, 141, 141)),),
                value: car.isChecked,
                onChanged: (bool? value){
                  setState(() {
                    car.isChecked = value ?? false;
                  });
                },
                activeColor: Colors.red,
                checkColor: Colors.white,
                
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Color.fromARGB(255, 211, 210, 210),
                thickness: 1,
              ),
              const SizedBox(height: 20),
              const Text(
                'Point de ramassage :',
                style: TextStyle(color: Color(0xFF311D64)),
              ),
              const SizedBox(width: 10.0),
              if (widget.latitude != null && widget.longitude != null) ...[
                Text(
                  '( ${widget.latitude}, ${widget.longitude})',
                  style: const TextStyle(color: Color.fromARGB(255, 141, 141, 141)),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartePage(latitude: 48.8566, longitude: 2.3522)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF311D64),
                    ),
                    child: const Text('Voir sur la carte', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 211, 210, 210),
                thickness: 1,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _sendData();
                },
                child: const Text('Envoyer'),
              ),
              const SizedBox(height: 20),
              
            ],
          ),
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
}
