import 'package:flutter/material.dart';
import 'glycemie.dart';
import 'graphique.dart';

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
      body: Column(
        children: [
          GlycemieCircle(
            selectedUnit: _selectedUnit,
            onUnitChanged: (newValue) {
              setState(() {
                _selectedUnit = newValue;
              });
            },
          ),

          SizedBox(height: 20), // Espace entre les deux blocs

          // Fond bleu en dessous du cercle
          Expanded(
            child: Container(
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

              // Conteneur pour le graphique
              child: GlycemicChart(),
            ),
          ),
        ],
      ),
    );
  }
}
