import 'package:diwe_front/model/Meal.dart';
import 'package:diwe_front/repas/meals_list.dart';
import 'package:flutter/material.dart';
import 'package:diwe_front/repas/carrousel.dart';
import 'package:diwe_front/repas/info_repas.dart';
import 'package:diwe_front/repas/photorepas.dart';
import 'package:diwe_front/service/repasService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class RepasPage extends StatefulWidget {
  RepasPage({Key? key}) : super(key: key);

  @override
  _RepasPageState createState() => _RepasPageState();
}

class _RepasPageState extends State<RepasPage> {
  List<Meals> meals = [];
  bool isLoading = true;
  final String _baseUrl = dotenv.get('URL_IMAGE'); // Assigner une chaîne vide si la valeur est nulle


  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    try {
      MealGet mealGet = MealGet();
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
    return  Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child:Column(
              children: [
                Container(color: Colors.white),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 5),
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
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Center(
                      child: Photorepas(),
                    ), 
                    SizedBox(height: 10),
                    meals.isNotEmpty
                    ? MealInfoWidget(
                      mealImage: _baseUrl + meals.first.imagePath,
                      calories: meals.first.calories.toInt(),
                      proteins: meals.first.calcium,
                      lipids: meals.first.lipids,
                      glucides: meals.first.glucids,
                      fibres: meals.first.fibers,
                      name: meals.first.name
                    ): Container(),
                    SizedBox(height: 10),
                    MealCarouselWidget(meals: meals),
                    SizedBox(height: 20),
                    GestureDetector(
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
                          color: Color(0xFFFFFFff),
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
              ],)
            ),
          ],
        ),
      )
    );
  }
}
