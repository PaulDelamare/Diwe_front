import 'package:flutter/material.dart';

class ButtonScanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Action à effectuer lorsque la carte est cliquée
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20), // Marge uniforme pour la card
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: () {
              // Action à effectuer lorsque la carte est cliquée
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.camera_alt, // Icône de l'appareil photo
                    color: Color(0xFF004396), // Couleur de l'icône
                    size: 30, // Taille de l'icône
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Scanner Mon Repas', // Texte modifié
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
