import 'package:flutter/material.dart';
import 'avatar.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0), // Ajoutez de l'espace au-dessus du fond bleu
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
          child: Stack(
            children: [
              Positioned(
                top: 20, // Ajustez cette valeur pour positionner l'avatar verticalement
                left: 0,
                right: 0,
                child: Center(
                  child: AvatarPage(), // Importez l'avatar ici
                ),
              ),
              // Ajoutez le reste du contenu ici
            ],
          ),
        ),
      ),
    );
  }
}
