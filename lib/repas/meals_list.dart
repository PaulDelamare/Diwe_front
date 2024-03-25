import 'package:diwe_front/service/repasService.dart';
import 'package:flutter/material.dart';
import 'package:diwe_front/model/Meal.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class MealsList extends StatefulWidget {
  @override
  _MealsListState createState() => _MealsListState();
}

class _MealsListState extends State<MealsList> {
  List<Meals> _meals = [];
  int _currentPage = 1;
  bool _isLoading = true;
  final String _baseUrl = dotenv.env['http://10.0.2.2:3000'] ?? ''; // Assigner une chaîne vide si la valeur est nulle


  @override
  void initState() {
    super.initState();
    _fetchMeals(_currentPage);
  }
// Fonction pour récupérer les repas en fonction de la page
  Future<void> _fetchMeals(int page) async {
    try {
      MealGet mealGet = MealGet(); // Initialise un objet MealGet pour récupérer les repas
      List<Meals> loadedMeals = await mealGet.fetchMealsWithPage(page); // Récupère les repas à partir de l'API avec la pagination

      setState(() {
        _meals.addAll(loadedMeals); // Ajoute les repas récupérés à la liste des repas existante
        _isLoading = false; // Indique que le chargement des repas est terminé
      });
    } on FetchMealsException catch (e) { // Gère les exceptions spécifiques à la récupération des repas
      print("Erreur lors de la récupération des repas: ${e.message}"); // Affiche un message d'erreur dans la console
      setState(() {
        _isLoading = false; // Indique que le chargement des repas est terminé
      });
    } catch (e) { // Gère les autres exceptions imprévues
      print("Erreur inattendue lors de la récupération des repas: $e"); // Affiche un message d'erreur dans la console
      setState(() {
        _isLoading = false; // Indique que le chargement des repas est terminé
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
