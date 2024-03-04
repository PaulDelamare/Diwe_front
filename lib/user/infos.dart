import 'package:flutter/material.dart';

class InfosWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center( // Centrer le contenu
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.transparent, // Fond transparent
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centrer le contenu
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centrer les enfants
              children: [
                Text(
                  'Nom',
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8), // Ajouter un espace entre Nom et Prénom
                Text(
                  'Prénom',
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'monemail@example.com', // Remplacer par l'email réel
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Affichage des informations supplémentaires en quatre cartes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoCard('Info 1', '...'),
                SizedBox(width: 20), // Ajuster l'espacement entre les cartes
                _buildInfoCard('Info 2', '...'),
              ],
            ),
            SizedBox(height: 20), // Ajuster l'espacement entre les rangées de cartes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoCard('Info 3', '...'),
                SizedBox(width: 20), // Ajuster l'espacement entre les cartes
                _buildInfoCard('Info 4', '...'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      color: Colors.blue, // Couleur de la carte
      elevation: 3, // Élévation de la carte
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Bord arrondi
      ),
      child: Padding(
        padding: const EdgeInsets.all(40.0), // Ajuster l'espace intérieur de la carte
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12), // Ajuster l'espace entre le titre et le contenu
            Text(
              content,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
