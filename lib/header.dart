import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'ListeCollaboPage.dart';


class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function(String) onSearchTextChanged;
  final bool isIntListeCollaboPage;

  const Header({
    required this.title,
    required this.onSearchTextChanged,
    this.isIntListeCollaboPage = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Row(
        children: [
          const SizedBox(width:5),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 22.0),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          color: Colors.white,
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          color: Colors.white,
          onPressed: () {},
        ),
      ],
      flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Recherche...",
                    hintStyle: TextStyle(color: Color.fromARGB(255, 252, 250, 250)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  onTap: () {
                    if (isIntListeCollaboPage == false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListeCollaboPage()),
                      );    
                    }
                  },
                  onChanged: (value) {
                    onSearchTextChanged(value);
                  },
                ),
              ),
            ),
          ],
        ),
      );    
  }
}

