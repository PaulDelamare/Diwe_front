import 'package:flutter/material.dart';

class ButtonBlogCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20), // Ajout de la même marge horizontale que celle utilisée dans le graphique.dart
      child: GestureDetector(
        onTap: () {
          // Action à effectuer lorsque la carte est cliquée
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: () {
              // Action à effectuer lorsque la carte est cliquée
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    'assets/blog.png', // Chemin de votre image dans le dossier assets
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Gérer le Diabète au Quotidien',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Spacer(), // Ajout d'un espace flexible pour pousser l'icône vers la droite
                      Icon(
                        Icons.arrow_forward, // Icone de la flèche
                        color: Color(0xFF004396), // Couleur de l'icône
                        size: 30, // Taille de l'icône
                      ),
                    ],
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
