import 'package:diwe_front/auth/login_page.dart';
import 'package:flutter/material.dart';
import '../custom/custom_input.dart';



class Authpage extends StatelessWidget {
  const Authpage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Grand cercle orange en bas à droite
          Positioned(
            right: 250,
            bottom: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFAB91).withOpacity(0.9),
              ),
            ),
          ),
          // Petit cercle orange en bas à droite
          Positioned(
            right: 130,
            bottom: 130,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFAB91).withOpacity(0.9),
              ),
            ),
          ),
          // Grand cercle orange en haut à gauche
          Positioned(
            right: -100,
            top: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFAB91).withOpacity(0.9),
              ),
            ),
          ),
          // Petit cercle orange en haut à gauche
          Positioned(
            left: 100,
            top: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFAB91).withOpacity(0.9),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 3),
                Image.asset(
                  'assets/images/diwe_logo.png',
                  width: 250,
                ),
                SizedBox(height: 80.0),
                CustomInput(
                  backgroundColor: Color(0xff004396),
                  borderColor: Colors.transparent,
                  placeholder: 'Connexion',
                  textColor: Colors.white,
                  width: 250.0,
                  onTap: () {
                    // Action à exécuter au tapotement
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()), // Assurez-vous que la destination est valide.
                    );
                  },
                ),
                SizedBox(height: 16),
                CustomInput(
                  backgroundColor: Color(0xff004396),
                  borderColor: Colors.transparent,
                  placeholder: 'Inscription',
                  textColor: Colors.white,
                  width: 250.0,
                  onTap: () {
                    // Action à exécuter au tapotement

                  },
                ),


                SizedBox(height: 16),
                // Si vous avez besoin d'un autre CustomInput ou d'un autre widget, ajoutez-le ici.
                Spacer(flex: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
