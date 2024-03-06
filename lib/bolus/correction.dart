import 'package:flutter/material.dart';

class CorrectionBlock extends StatelessWidget {
  const CorrectionBlock({Key? key}) : super(key: key);

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
          // Texte "CORRECTION" en haut à gauche
          Positioned(
            top: 7,
            left: 10,
            child: Text(
              'CORRECTION',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004396),
              ),
            ),
          ),
          // Valeur "0.0u" centrée verticalement
          Center(
            child: Text(
              '0.0u',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004396),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
