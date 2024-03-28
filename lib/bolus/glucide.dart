import 'package:flutter/material.dart';

class GlucideBlock extends StatelessWidget {
  const GlucideBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF004396), width: 3),
      ),
      child: Stack(
        children: [
          // Texte "GLUCIDE" en haut à gauche
          Positioned(
            top: 7,
            left: 10,
            child: Text(
              'GLUCIDES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004396),
              ),
            ),
          ),
          // Valeurs "15g" et "2.0u" centrées verticalement
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '15g',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004396),
                  ),
                ),
                Text(
                  '2.0u',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004396),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
