import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'my_home_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key ?? const Key('default_key'));

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  String nom = '';
  String prenom = '';
  String email = '';
  String keyQr = '';
  bool obscureText = true;
  bool isObscure = true;
  String? collaborateurId;

  Future<void> _verifyPassword() async {
    const String apiUrl = 'http://10.163.13.69:8080/collaborateur/verifyPassword';

    try {
      print('Sending request to $apiUrl');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'key_qr': keyQr  
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'OK') {
          collaborateurId = responseBody['id'];

          
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('collaborateurId', collaborateurId!);

          Fluttertoast.showToast(msg: 'Login successful');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                title: "accueil",
                collaborateurId: collaborateurId!,
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: 'Invalid credentials, please try again');
        }
      } else {
        Fluttertoast.showToast(msg: 'Invalid credentials, please try again');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'Error connecting to server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('WELCOME', style: TextStyle(color: Color(0xFF311D64))),
            const SizedBox(height: 50.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    nom = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'FirstName...',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    prenom = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Lastname...',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Email...',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    keyQr = value;
                  });
                },
                obscureText: obscureText, 
                decoration: InputDecoration(
                  hintText: 'Password...',
                  contentPadding: const EdgeInsets.all(20.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                        obscureText = !obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyPassword,
              child: const Text('LogIn'),
            ),
          ],
        ),
      ),
    );
  }
}
