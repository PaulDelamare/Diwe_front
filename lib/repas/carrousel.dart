import 'package:flutter/material.dart';
import 'package:diwe_front/model/Meal.dart'; // Assurez-vous que le chemin d'importation est correct
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MealCarouselWidget extends StatelessWidget {
  final List<Meals> meals;
  final String _baseUrl = dotenv.get('URL_IMAGE'); // Assigner une chaîne vide si la valeur est nulle

  MealCarouselWidget({Key? key, required this.meals}) : super(key: key);

  Widget _buildMeal(Meals meal) {
    // Print des détails du repas pour déboguer
    print('Détails du repas : $meal');

    // Concaténez _baseUrl avec imagePath pour obtenir une URL complète
    String imageUrl = _baseUrl + meal.imagePath;
    print('URL de l\'image : $imageUrl');

    return Container(
      width: 70,
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageUrl), // Utilisez l'URL complète ici
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Center(child: Text('Aucun repas à afficher'));
    }

    final Color backgroundColor = Color(0xFF004396);

    double totalWidth = meals.length * 90;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Aujourd\'hui',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          SizedBox(
            height: 100,
            child: totalWidth < MediaQuery.of(context).size.width
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: meals.map(_buildMeal).toList(),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: meals.length,
              itemBuilder: (context, index) => _buildMeal(meals[index]),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Total ${meals.fold(0, (total, meal) => total + meal.calories)} kcal',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
