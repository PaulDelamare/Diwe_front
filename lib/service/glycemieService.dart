import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GlycemieService {
  static Future<List<double>> getGlycemieData() async {
    // Chargez les variables d'environnement à partir du fichier .env
    await dotenv.load();

    // Récupérez la clé d'API à partir du fichier .env
    final apiKey = dotenv.env['API_KEY'];

    // Vérifiez si la clé d'API est null ou vide
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is missing or empty');
    }

    // Effectuez une requête HTTP pour récupérer les données de glycémie
    final response = await http.get(
      Uri.parse('${dotenv.env['API_HOST']}glycemie'), // Utilisez la variable API_HOST du .env
      headers: {
        'x-api-key': apiKey, // Ajoutez la clé d'API dans l'en-tête
      },
    );

    if (response.statusCode == 200) {
      // Analysez la réponse JSON
      final jsonData = json.decode(response.body);

      // Récupérez les valeurs de glycémie et retournez-les
      final double mmolLValue = jsonData['mmolLValue'];
      final double mgdlValue = jsonData['mgdlValue'];
      return [mmolLValue, mgdlValue];
    } else {
      // En cas d'erreur, lancez une exception avec le message d'erreur
      throw Exception('Failed to load glycemie data');
    }
  }
}
