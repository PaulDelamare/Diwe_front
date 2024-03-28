import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String nom;
  final String prenom;
  final String email;

  const ProfileWidget({
    Key? key,
    required this.nom,
    required this.prenom,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center( // Centre le Container dans son parent
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75, // Taille relative à l'écran
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement dans le Container
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centre les éléments dans la Row
              mainAxisSize: MainAxisSize.min, // Utilise l'espace minimal requis pour la Row
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.blue.shade800,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Centre les éléments dans la Column
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min, // Taille minimale pour la Row interne
                      children: [
                        Text(nom, style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 5), // Petit espace entre le nom et le prénom
                        Text(prenom, style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 5), // Espacement entre le nom/prénom et l'email
                    Text(email), // Email en dessous
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
