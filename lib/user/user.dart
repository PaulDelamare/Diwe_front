import 'package:diwe_front/main.dart';
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
            // Fond bleu
            Positioned(
              top: 0, // Hauteur de l'espace au-dessus du fond bleu
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
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Naviguer vers la page des paramètres
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyHomePage(selectedIndex: 5)),
                  );
                  },
              ),
            ),
            // Avatar
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: AvatarPage(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 120.0),
              child: Center(
                child: InfosWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
