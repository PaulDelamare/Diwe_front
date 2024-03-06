import 'package:flutter/material.dart';
import 'package:diwe_front/home/glycemie.dart'; // Import du fichier glycemie.dart

class BolusPage extends StatelessWidget {
  const BolusPage({Key? key}) : super(key: key);

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
              top: 220, // Ajustez la position verticale selon vos besoins
              left: 40, // Ajustez la position horizontale selon vos besoins
              child: _GlycemieCircleWidget(), // Utilisation du nouveau widget pour la glycémie
            ),
          ],
        ),
      ),
    );
  }
}

class _GlycemieCircleWidget extends StatefulWidget {
  const _GlycemieCircleWidget({Key? key}) : super(key: key);

  @override
  __GlycemieCircleWidgetState createState() => __GlycemieCircleWidgetState();
}

class __GlycemieCircleWidgetState extends State<_GlycemieCircleWidget> {
  String? _selectedUnit = 'mmol/L';
  double _mmolLValue = 5; // Valeur glycémique par défaut en mmol/L
  double _mgdlValue = 112.0; // Valeur glycémique par défaut en mg/dl

  // Méthode pour convertir la valeur glycémique en mg/dl
  void _convertToMgdl(double mmolLValue) {
    setState(() {
      _mgdlValue = mmolLValue * 18.018;
    });
  }

  // Méthode pour convertir la valeur glycémique en mmol/L
  void _convertToMmolL(double mgdlValue) {
    setState(() {
      _mmolLValue = mgdlValue / 18.018;
    });
  }

  // Fonction de gestion du changement d'unité de mesure
  void _handleUnitChange(String? newUnit) {
    setState(() {
      _selectedUnit = newUnit;
      if (_selectedUnit == 'mmol/L') {
        _convertToMmolL(_mgdlValue);
      } else {
        _convertToMgdl(_mmolLValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlycemieCircle(
      selectedUnit: _selectedUnit,
      onUnitChanged: _handleUnitChange,
    );
  }
}
