import 'package:flutter/material.dart';
import 'avatar.dart';
import 'infos.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Centrer le contenu de UserPage
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
            // Icon Paramètres
            Positioned(
              top: 75,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Naviguer vers la page des paramètres
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
            // Avatar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: AvatarPage(),
              ),
            ),
            // Icon edit
            Positioned(
              top: 75,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.mode_edit, color: Colors.white),
                onPressed: () {
                  // Naviguer vers la page des modifications
                  Navigator.pushNamed(context, '/edit');
                },
              ),
            ),
            // InfosWidget
            Positioned(
              top: 220, // Ajustez la position verticale selon vos besoins
              left: 40, // Ajustez la position horizontale selon vos besoins
              child: InfosWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
