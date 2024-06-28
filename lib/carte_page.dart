import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'detail_page.dart';
import 'header.dart';
import 'insertCollabo_page.dart';
import 'ListeCollaboPage.dart';
import 'my_home_page.dart';
import 'profil_page.dart';
import 'car_temp.dart';
import 'package:latlong2/latlong.dart'; // Assurez-vous que c'est correct si utilisé


class CartePage extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  const CartePage({Key? key , required this.latitude , required this.longitude}) : super(key: key);
  

  @override
  _CartePageState createState() => _CartePageState();
}

class _CartePageState extends State<CartePage> {
  
  List<Marker> markers = [];
  late MapController mapController;
  LatLng tappedPoint = const LatLng(47.5155, -18.9042);
  String clickName = '';
  
  @override
  void initState(){
    super.initState();
    mapController= MapController();
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: "Carte",
        onSearchTextChanged: (text) {},
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
              title: const Text('Demande Car Temporaire', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85) , fontSize: 12.0)) ,
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
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context , MaterialPageRoute(builder: (context) => const CartePage(latitude: 47.5338, longitude: -18.9181)));
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
      body: content(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarTempPage(
                latitude: tappedPoint.latitude,
                longitude: tappedPoint.longitude,
              ),
            ),
          );
        },
        child: const Icon(Icons.navigate_before),
      ),
    );
  }

 Widget content() {
  return FlutterMap(
    options: MapOptions(
      initialCenter: const LatLng(47.5155, -18.9042),
      initialZoom: 15.0,
      onTap: (tapPosition, latLng) => _handleTap(latLng, ''),
    ),
    mapController: mapController,
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: const ['a', 'b', 'c'],
      ),
      MarkerLayer(markers: markers),
    ],
  );
}

  void _handleTap(LatLng tappedLocation , String pointName) { 
    setState(() {
      tappedPoint = tappedLocation;
      markers.clear();
      markers.add(
        Marker(
          width: 150.0,
          height: 150.0,
          point: tappedPoint,
          child: Column(
            mainAxisSize: MainAxisSize.min,
               children: [
                  Container(
                    padding:const  EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow:const  [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Latitude: ${tappedPoint.latitude.toStringAsFixed(4)}",
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          "Longitude: ${tappedPoint.longitude.toStringAsFixed(4)}",
                          style:const  TextStyle(color: Colors.black),
                        ),
                        
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.pin_drop,
                    color: Colors.red,
                    size: 40.0,
                  ),
                  
              ],
          ),
        ),
      );
    });
  }

}
