import 'package:flutter/material.dart';

class Converter {
  static double mmolToMgdl(double mmol) {
    return mmol * 18.0182;
  }

  static double mgdlToMmol(double mgdl) {
    return mgdl / 18.0182;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedUnit = 'mmol/L'; // Unité par défaut
  double _glucoseValue = 6.2; // Valeur par défaut du glucose

  void _updateGlucoseValue(double newValue) {
    setState(() {
      _glucoseValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            child: Stack(
              children: [
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
                Center(
                  child: Container(
                    width: 185,
                    height: 185,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        '$_glucoseValue', // Affiche la valeur du glucose
                        style: TextStyle(
                          color: Color(0xFF004396),
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
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
                            if (_selectedUnit != newValue) {
                              _selectedUnit = newValue!;
                              if (_selectedUnit == 'mg/dl') {
                                _glucoseValue = Converter.mmolToMgdl(_glucoseValue);
                              } else {
                                _glucoseValue = Converter.mgdlToMmol(_glucoseValue);
                              }
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
                Positioned(
                  bottom: 80,
                  left: 150,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF004396),
                    size: 45,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
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
            ),
          ),
        ],
      ),
    );
  }
}
