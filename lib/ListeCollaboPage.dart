import 'package:flutter/material.dart';
import 'package:flutter_application_1/map_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_page.dart';
import 'header.dart'; 
import 'profil_page.dart';
import 'my_home_page.dart';
import 'insertCollabo_page.dart';
import 'car_temp.dart';

enum AxisSelection { xAxis, yAxis, none }

class Collaborateur {
  String nom;
  String prenom;
  String matricule;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isValidated; 
  bool showConfirmation;

  Collaborateur(this.nom, this.prenom, this.matricule)
      : isValidated = false,
      showConfirmation = false; // Initialisation à false lors de la création
}

class ListeCollaboPage extends StatefulWidget {
  @override
  _ListeCollaboPageState createState() => _ListeCollaboPageState();
}

class _ListeCollaboPageState extends State<ListeCollaboPage> {
  List<Collaborateur> collaborateurs = [];
  List<Collaborateur> filteredCollaborateurs = [];
  AxisSelection selectedAxis = AxisSelection.none;

  @override
  void initState() {
    super.initState();
    _chargerCollaborateurs();
  }

  Future<void> _selectDate(BuildContext context, Collaborateur collaborateur, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? collaborateur.startDate : collaborateur.endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          collaborateur.startDate = picked;
        } else {
          collaborateur.endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: "Liste Collaborateur",
        onSearchTextChanged: filterCollaborateurs,
        isIntListeCollaboPage: true,
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
              title: const Text('Paramètre', style: TextStyle(color: Color.fromARGB(255, 85, 85, 85), fontSize: 12.0)), 
              leading: const Icon(Icons.settings),
              iconColor: Colors.red,
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
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (filteredCollaborateurs.isEmpty)
                const Center(
                  child: Text('Aucun collaborateur trouvé'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredCollaborateurs.length,
                  itemBuilder: (context, index) {
                    Collaborateur collaborateur = filteredCollaborateurs[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          '${collaborateur.nom} ${collaborateur.prenom} Matricule: ${collaborateur.matricule}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.grey,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Choisir ${collaborateur.nom} ${collaborateur.prenom} comme intérim (Chef de car)', style: const TextStyle(color: Colors.grey)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Date de début :',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${collaborateur.startDate.day}/${collaborateur.startDate.month}/${collaborateur.startDate.year}',
                                            style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 141, 141, 141)),
                                          ),
                                          const SizedBox(height: 5),
                                          ElevatedButton(
                                            child: const Text('Sélectionner une date'),
                                            onPressed: () => _selectDate(context, collaborateur, true),
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            'Date de fin :',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${collaborateur.endDate.day}/${collaborateur.endDate.month}/${collaborateur.endDate.year}',
                                            style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 141, 141, 141)),
                                          ),
                                          const SizedBox(height: 5),
                                          ElevatedButton(
                                            child: const Text('Sélectionner une date'),
                                            onPressed: () => _selectDate(context, collaborateur, false),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              collaborateur.isValidated = true;
                                              _sauvegarderCollaborateurs(); // Sauvegarder l'état
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Envoyer'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.grey,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Supprimer ${collaborateur.nom} ${collaborateur.prenom}'),
                                      content: const Text('Voulez-vous vraiment supprimer ce collaborateur ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              collaborateurs.removeAt(index);
                                              filteredCollaborateurs = collaborateurs;
                                              _sauvegarderCollaborateurs(); // Sauvegarder l'état
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Supprimer'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            if (collaborateur.isValidated)
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () {
                                  _showConfirmationDialog(collaborateur);
                                },
                              ), 
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertCollaboPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _chargerCollaborateurs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? collaborateursEnregistres = prefs.getStringList('collaborateurs');
    if (collaborateursEnregistres != null) {
      setState(() {
        collaborateurs = collaborateursEnregistres.map((collabString) {
          List<String> infosCollaborateur = collabString.split(' ');
          if (infosCollaborateur.length >= 4) {
            String nom = infosCollaborateur[0];
            String prenom = infosCollaborateur[1];
            String matricule = infosCollaborateur[2];
            bool isValidated = infosCollaborateur[3] == 'true';
            Collaborateur collaborateur = Collaborateur(nom, prenom, matricule);
            collaborateur.isValidated = isValidated;
            return collaborateur;
          } else {
            return Collaborateur('', '', '');
          }
        }).toList();
        filteredCollaborateurs = collaborateurs;
      });
    }
  }

  void filterCollaborateurs(String query) {
    setState(() {
      filteredCollaborateurs = collaborateurs
          .where((collaborateur) =>
              '${collaborateur.nom} ${collaborateur.prenom} ${collaborateur.matricule}'.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _sauvegarderCollaborateurs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> collaborateursEnregistres = collaborateurs.map((collab) {
      return '${collab.nom} ${collab.prenom} ${collab.matricule} ${collab.isValidated}';
    }).toList();
    prefs.setStringList('collaborateurs', collaborateursEnregistres);
  }

  void _showConfirmationDialog(Collaborateur collaborateur) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer l\'annulation'),
          content: const Text('Voulez-vous vraiment annuler la désignation d\'itérim ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  collaborateur.isValidated = false;
                  _sauvegarderCollaborateurs(); // Sauvegarder l'état
                });
                Navigator.of(context).pop();
              },
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );
  }
}
