import 'dart:async'; // Ajoutez cette ligne pour accéder à Timer
import 'package:flutter/material.dart';
import '/../service/glycemieService.dart'; // Importez votre service API

class GlycemieCircle extends StatefulWidget {
  final String? selectedUnit;
  final ValueChanged<String?> onUnitChanged;

  const GlycemieCircle({
    Key? key,
    required this.selectedUnit,
    required this.onUnitChanged,
  }) : super(key: key);

  @override
  _GlycemieCircleState createState() => _GlycemieCircleState();
}

class _GlycemieCircleState extends State<GlycemieCircle> {
  double _mmolLValue = 5; // Valeur glycémique par défaut en mmol/L
  double _mgdlValue = 112.0; // Valeur glycémique par défaut en mg/dl
  Timer? _timer; // Variable pour le Timer


  @override
  void initState() {
    super.initState();
    // Appel de la méthode pour récupérer les données de glycémie lors de l'initialisation du widget
    _fetchGlycemieData();
    // Démarre un Timer qui appelle _fetchGlycemieData toutes les 10 secondes
    _timer = Timer.periodic(Duration(seconds: 2), (Timer t) => _fetchGlycemieData());
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annuler le Timer quand le widget est détruit
    super.dispose();
  }

  // Méthode pour récupérer les données de glycémie à partir du service API
  void _fetchGlycemieData() async {
    try {
      final glycemieData = await GlycemieService.getGlycemieData();
      if (!mounted) return; // Vérifiez si le widget est toujours monté avant de déclencher setState
      setState(() {
        // Mettre à jour les valeurs de glycémie
        _mmolLValue = glycemieData[0];
        _mgdlValue = glycemieData[1];
      });
    } catch (e) {
      print('Error fetching glycemie data: $e');
    }
  }

  // Méthodes de conversion et de gestion du changement d'unité omises pour la clarté

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  colors: [
                    Color(0xFF004396),
                    Color(0xFF0C8CE9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Conteneur du cercle blanc
          Center(
            child: Container(
              width: 185,
              height: 185,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),

              // Texte avec valeur glycémique ajustée au cercle
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    (widget.selectedUnit == 'mmol/L') ? _mmolLValue.toStringAsFixed(1) : _mgdlValue.toStringAsFixed(1),
                    style: TextStyle(
                      color: (((widget.selectedUnit == 'mmol/L') && (_mmolLValue < 3.2 || _mmolLValue > 9.9)) ||
                          ((widget.selectedUnit == 'mg/dl') && (_mgdlValue < 59 || _mgdlValue > 179)))
                          ? Color(0xFFFF914D) // Couleur en dehors de la plage normale
                          : Color(0xFF004396), // Couleur normale
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
                  value: widget.selectedUnit,
                  onChanged: (newValue) {
                    if (newValue != widget.selectedUnit) {
                      widget.onUnitChanged(newValue);
                      if (newValue == 'mmol/L') {
                        _convertToMmolL(_mgdlValue);
                      } else {
                        _convertToMgdl(_mmolLValue);
                      }
                    }
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
    );
  }

  // Méthodes de conversion et de gestion du changement d'unité omises pour la clarté

  void _convertToMgdl(double mmolLValue) {
    setState(() {
      _mgdlValue = mmolLValue * 18.018;
    });
  }

  void _convertToMmolL(double mgdlValue) {
    setState(() {
      _mmolLValue = mgdlValue / 18.018;
    });
  }
}
