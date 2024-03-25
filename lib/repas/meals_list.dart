import 'package:diwe_front/service/repasService.dart';
import 'package:flutter/material.dart';
import 'package:diwe_front/model/Meal.dart';

class MealsList extends StatefulWidget {
  @override
  _MealsListState createState() => _MealsListState();
}

class _MealsListState extends State<MealsList> {
  List<Meals> _meals = [];
  int _currentPage = 1;
  bool _isLoading = true;
  final String _baseUrl = 'http://10.0.2.2:3000/'; // Remplacez par l'URL réelle de votre serveur


  @override
  void initState() {
    super.initState();
    _fetchMeals(_currentPage);
  }

  Future<void> _fetchMeals(int page) async {
    try {
      MealGet mealGet = MealGet();
      List<Meals> loadedMeals = await mealGet.fetchMealsWithPage(page);

      setState(() {
        _meals.addAll(loadedMeals);
        _isLoading = false;
      });
    } on FetchMealsException catch (e) {
      print("Erreur lors de la récupération des repas: ${e.message}");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur inattendue lors de la récupération des repas: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMoreMeals() {
    setState(() {
      _currentPage++;
    });
    _fetchMeals(_currentPage);
  }
  void _deleteMealbyID(Meals meal) async {
    try {
      // Ajoutez un print pour afficher l'identifiant du repas
      print('Identifiant du repas à supprimer : ${meal.id}');

      MealGet mealGet = MealGet();

      // Appelez votre méthode deleteMeal du service repasService
      await mealGet.deleteMeal(meal.id); // Supposant que meal.id est l'identifiant unique du repas
      // Après avoir supprimé le repas avec succès, vous pouvez mettre à jour l'état de votre liste de repas pour refléter les changements
      setState(() {
        _meals.remove(meal);
      });
    } catch (error) {
      print('Erreur lors de la suppression du repas: $error');
      // Gérez l'erreur ici
    }
  }





  void _deleteMeal(int index) {
    setState(() {
      _meals.removeAt(index);
    });
    // Ajoutez ici la logique pour supprimer le repas
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_meals.isEmpty) {
      return Center(child: Text('Aucun repas trouvé'));
    }

    return SingleChildScrollView(
      child: Column(
        children: List.generate(_meals.length + 1, (index) {
          if (index < _meals.length) {
            // Affichez les informations du repas ici
            final meal = _meals[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(meal.name),
                    subtitle: Text('Glucides : ${meal.glucids} g'),
                    trailing: Text('Calories : ${meal.calories} kcal'),

                  ),
                  // Bouton de suppression
                  ElevatedButton(
                    onPressed: () => _deleteMealbyID(meal),
                    child: Text('Supprimer'),
                  ),

                ],
              ),
            );
          } else {
            // Affichez un bouton pour charger plus de repas
            return ElevatedButton(
              onPressed: _loadMoreMeals,
              child: Text('Charger plus de repas'),
            );
          }
        }),
      ),
    );
  }
}
