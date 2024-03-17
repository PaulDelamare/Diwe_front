import 'package:diwe_front/Auth/register.dart';
import 'package:diwe_front/auth/login_page.dart';
import 'package:diwe_front/custom/background_bubble_custom.dart';
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
          BackgroundBubble(right: 250,bottom: -120 ,color: Color(0xFFFFAB91).withOpacity(0.9), width: 300, height: 300),
          // Petit cercle orange en bas à droite
          BackgroundBubble(right: 130,bottom: 130 ,color: Color(0xFFFFAB91).withOpacity(0.9), width: 80, height: 80),
          // Grand cercle orange en haut à gauche
          BackgroundBubble(right: -100,top: -80 ,color: Color(0xFFFFAB91).withOpacity(0.9), width: 300, height: 300),
          // Petit cercle orange en haut à gauche
          BackgroundBubble(left: 100,top: 40 ,color: Color(0xFFFFAB91).withOpacity(0.9), width: 80, height: 80),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterPage()), // Assurez-vous que la destination est valide.
                    );
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
