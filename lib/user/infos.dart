import 'package:flutter/material.dart';

class InfosWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            'Informations supplémentaires:',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Info 1: ...',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            'Info 2: ...',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            'Info 3: ...',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            'Info 4: ...',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
