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
      body: Stack(
        children: [
          // Espace au-dessus du fond bleu avec l'icône Paramètres
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100, // Hauteur de l'espace au-dessus du fond bleu
            child: Container(
              color: Colors.white, // Couleur de l'espace au-dessus du fond bleu
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // Naviguer vers la page des paramètres
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
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
          // Avatar
          Positioned(
            top: 0, // Ajustez la position de l'avatar pour le rendre partiellement visible dans l'espace
            left: 0,
            right: 0,
            child: Center(
              child: AvatarPage(),
            ),
          ),
        ],
      ),
    );
  }
}
