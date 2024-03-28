import 'package:flutter/material.dart';

class SuggestionBlock extends StatelessWidget {
  const SuggestionBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF004396), width: 3),
      ),
      child: Stack(
        children: [
          // Texte "BOLUS SUGGERÉ" en haut à gauche
          Positioned(
            top: 7,
            left: 10,
            child: Text(
              'BOLUS SUGGÉRÉ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004396),
              ),
            ),
          ),
          // Valeur "2.0u" centrée verticalement
          Center(
            child: Text(
              '2.0u',
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
