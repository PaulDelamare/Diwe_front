import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MealInfoWidget extends StatelessWidget {
  final String mealImage;
  final int calories;
  final int proteins;
  final int lipids;
  final int glucides;
  final int fibres;

  const MealInfoWidget({
    Key? key,
    required this.mealImage,
    required this.calories,
    required this.proteins,
    required this.lipids,
    required this.glucides,
    required this.fibres,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color:  Color(0xFF004396),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row( // Changed to a Row widget to layout image and info side by side
          children: [
            Column(
              children: [
                Text(
                  'Dernier repas',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0), // Circular clip for image
                  child: Image.network(mealImage, height: 120, width: 120, fit: BoxFit.cover,), // Make sure 'mealImage' is a valid URL
                ),
              ],
            ),
            SizedBox(width: 16.0), // Space between image and nutritional info
            Expanded( // Wrap the column with Expanded to take the remaining space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${calories}kcal',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _buildNutritionRow('Protéines', proteins, Colors.orange, context),
                  _buildNutritionRow('Lipides', lipids, Colors.red, context),
                  _buildNutritionRow('Glucides', glucides, Colors.green, context),
                  _buildNutritionRow('Fibres', fibres, Colors.yellow, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String nutrient, int value, Color color, BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 2; // Adjust the width of the progress bar according to your layout
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded( // Wrap the text in an Expanded to ensure it takes up the appropriate space
            flex: 2, // Adjust the flex to control the size of the text relative to the progress bar
            child: Text(
              nutrient,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 3, // Adjust the flex to control the size of the progress bar relative to the text
            child: Container(
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    width: maxWidth * (value / 100), // Calculate the width of the filled part
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 10), // Space between the progress bar and the gram text
      Text(
        '${value}g',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10, // Correctement spécifié en points, sans "px"
        ),
        overflow: TextOverflow.ellipsis, // Ajoute des points de suspension si le texte dépasse
      ),

        ],
      ),
    );
  }
}
