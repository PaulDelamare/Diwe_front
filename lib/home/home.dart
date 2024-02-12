import 'package:flutter/material.dart';

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
  String _selectedUnit = 'mmol/L'; // Unité par défaut
  double _glycemicValue = 6.2; // Valeur glycémique par défaut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          // Cercle glycémique
          Container(
            width: 200,
            height: 200,
            child: Stack(
              children: [
                // Dégradé de fond du cercle
                Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF004396), Color(0xFF0C8CE9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Conteneur blanc du cercle
                Center(
                  child: Container(
                    width: 185,
                    height: 185,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      // Texte avec valeur glycémique ajustée au cercle
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _glycemicValue.toStringAsFixed(1),
                          style: TextStyle(
                            color: Color(0xFF004396),
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Sélecteur d'unité de mesure
                Positioned(
                  bottom: 45,
                  left: 90,
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: _selectedUnit,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedUnit = newValue!;
                            // Mise à jour de la valeur glycémique en fonction de l'unité sélectionnée
                            if (_selectedUnit == 'mmol/L') {
                              _glycemicValue = 6.2; // Valeur arbitraire en mmol/L
                            } else {
                              _glycemicValue = 112; // Valeur arbitraire en mg/dl
                            }
                          });
                        },
                        items: <String>['mmol/L', 'mg/dl'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Color(0xFF004396), // Couleur du texte
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
              // Autres widgets à l'intérieur de ce conteneur
            ),
          ),
        ],
      ),
    );
  }
}
