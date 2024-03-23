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

  @override
  void initState() {
    super.initState();
    _fetchMeals(_currentPage);
  }

  Future<void> _fetchMeals(int page) async {
    try {
      MealGet mealGet = MealGet();
      String apiKey = 'your_api_key_here';
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
            return ListTile(
              title: Text(meal.name),
              subtitle: Text('Glucides : ${meal.glucids} g'),
              trailing: Text('Calories : ${meal.calories} kcal'),
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

