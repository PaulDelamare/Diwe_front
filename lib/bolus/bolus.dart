import 'package:flutter/material.dart';
import 'package:diwe_front/home/glycemie.dart';

class BolusPage extends StatefulWidget {
  const BolusPage({Key? key}) : super(key: key);

  @override
  _BolusPageState createState() => _BolusPageState();
}

class _BolusPageState extends State<BolusPage> {
  late String _selectedUnit; // Unité de mesure sélectionnée

  @override
  void initState() {
    super.initState();
    _selectedUnit = 'mmol/L'; // Initialisation de l'unité de mesure sélectionnée
  }

  // Fonction de gestion du changement d'unité de mesure
  void _handleUnitChange(String? newUnit) {
    setState(() {
      _selectedUnit = newUnit!;
    });
  }

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
                  onUnitChanged: _handleUnitChange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
