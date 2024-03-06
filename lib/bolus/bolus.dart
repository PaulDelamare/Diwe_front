import 'package:flutter/material.dart';
import 'glycemie.dart';

class BolusPage extends StatefulWidget {
  const BolusPage({Key? key}) : super(key: key);

  @override
  _BolusPageState createState() => _BolusPageState();
}

class _BolusPageState extends State<BolusPage> {
  String? _selectedUnit = 'mmol/L';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // Espace au-dessus du fond bleu
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100, // Hauteur de l'espace au-dessus du fond bleu
              child: Container(
                color: Colors.white, // Couleur de l'espace au-dessus du fond bleu
              ),
            ),
            // Fond bleu
            Positioned(
              top: 70, // Hauteur de l'espace au-dessus du fond bleu
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF004396), Color(0xFF0C8CE9)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            // GlycemieWidget
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: GlycemieCircle(
                  selectedUnit: _selectedUnit,
                  onUnitChanged: (newValue) {
                    setState(() {
                      _selectedUnit = newValue;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
