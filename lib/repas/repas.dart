import 'package:diwe_front/model/Meal.dart';
import 'package:diwe_front/repas/meals_list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:diwe_front/repas/carrousel.dart';
import 'package:diwe_front/repas/info_repas.dart';
import 'package:diwe_front/repas/photorepas.dart';
import 'package:diwe_front/service/repasService.dart';

class RepasPage extends StatefulWidget {
  RepasPage({Key? key}) : super(key: key);

  @override
  _RepasPageState createState() => _RepasPageState();
}

class _RepasPageState extends State<RepasPage> {
  List<Meals> meals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    try {
      MealGet mealGet = MealGet();
      String apiKey = 'your_api_key_here';
      List<Meals> loadedMeals = await mealGet.fetchMeals();

      setState(() {
        meals = loadedMeals;
        isLoading = false;
      });
    } on FetchMealsException catch (e) {
      print("Erreur lors de la récupération des repas: ${e.message}");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Erreur inattendue lors de la récupération des repas: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(color: Colors.white),
          ),
          Positioned(
            top: 70,
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
          Positioned(
            top: 75,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {},
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Photorepas(),
            ),
          ),
          Positioned(
            top: 75,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.mode_edit, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/edit');
              },
            ),
          ),
          Positioned(
            top: 220,
            left: 10,
            right: 10,
            child: MealInfoWidget(
              // Ici, vous devez ajuster pour utiliser les données de `meals`
              // Ceci est juste un placeholder
              mealImage: 'https://cdn.foodvisor.io/img/vision/examples/4.jpg',
              calories: 505,
              proteins: 42,
              lipids: 19,
              glucides: 39,
              fibres: 7,
            ),
          ),
          Positioned(
            top: 480,
            left: 10,
            right: 10,
            // Utilisez les données dynamiques pour le carousel
            child: MealCarouselWidget(meals: meals),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child : GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Historique des repas'),
                      content: MealsList(), // Remplacez MealsList() par le widget que vous souhaitez afficher dans la boîte de dialogue
                      actions: <Widget>[
                        TextButton(
                          child: Text('Fermer'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Voir l\'historique',
                style: TextStyle(
                  color: Color(0xFF004396),
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),


        ],
      ),
    );
  }
}
