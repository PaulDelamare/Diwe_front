import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color buttonColor;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.textColor,
    required this.buttonColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF004396)), // Bordure pour tous les boutons
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Couleur de l'ombre
            spreadRadius: 2, // Rayon de diffusion
            blurRadius: 5, // Flou de l'ombre
            offset: Offset(0, 2), // Décalage de l'ombre
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18, // Taille de police plus grande
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


class ButtonRow extends StatelessWidget {
  const ButtonRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          text: 'Réinitialiser',
          textColor: Color(0xFF004396),
          buttonColor: Colors.white,
          onPressed: () {
            // Action pour le bouton Réinitialiser
          },
        ),
        CustomButton(
          text: 'Enregistrer',
          textColor: Colors.white,
          buttonColor: Color(0xFF004396),
          onPressed: () {
            // Action pour le deuxième bouton
          },
        ),
      ],
    );
  }
}
