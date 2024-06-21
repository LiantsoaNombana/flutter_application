import 'package:flutter/material.dart';
import 'my_home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définition de la couleur d'arrière-plan personnalisée
    Color customBackground = Colors.grey.shade200;

    return MaterialApp(
      title: 'Flutter Démo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          backgroundColor: customBackground, 
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
          titleLarge: const  TextStyle(
            color: Colors.red,
            
            
          ),
        ),
      ),
      home: const MyHomePage(title: 'Geolocation-Pulse-Shuttle', collaborateurId: "id" ),
      
    );
  }
}
