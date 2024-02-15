import 'package:flutter/material.dart';
import 'glycemie.dart';
import 'graphique.dart';
import 'buttonBlog.dart';
import 'buttonOrdonnance.dart';
import 'buttonScanne.dart';


//note a moi même faire un dossier images dans le dossier assets



void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedUnit = 'mmol/L';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GlycemieCircle(
              selectedUnit: _selectedUnit,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedUnit = newValue;
                });
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Alignement vers la droite
              children: [
                GestureDetector(
                  onTap: () {
                    // Action à effectuer lorsque la partie est cliquée
                    // Naviguer vers la page d'email
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 20), // Espacement vers la droite
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF0C8CE9), // Couleur de fond du cercle
                      radius: 30, // Rayon réduit du cercle
                      child: Icon(
                        Icons.mail, // Icône lettre
                        color: Colors.white, // Couleur de l'icône
                        size: 35, // Taille de l'icône réduite
                      ),
                    ),
                  ),
                ),
              ],
            ),


            SizedBox(height: 10), // Espace entre l'icône et la partie fond bleu
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF004396), Color(0xFF0C8CE9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 5),
                  GlycemicChart(),

                  SizedBox(height: 25),
                  ButtonBlogCard(),

                  ButtonOrdonnanceCard(),

                  ButtonScanCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
