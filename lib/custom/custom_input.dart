import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final String placeholder;
  final Color textColor;
  final double width;
  final VoidCallback? onTap; // Utiliser onTap pour la redirection

  const CustomInput({
    Key? key,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.blue,
    this.placeholder = '',
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.onTap, // Initialiser onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Exécuter la fonction passée en paramètre lors du tap
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 8.0), // Ajouter un peu de padding pour le texte
        alignment: Alignment.center, // Centrer le texte à l'intérieur du conteneur
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: borderColor, // Utiliser borderColor pour la bordure
            width: 1.5, // Épaisseur de la bordure
          ),
        ),
        child: Text(
          placeholder,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor, fontSize: 20),
        ),
      ),
    );
  }
}
