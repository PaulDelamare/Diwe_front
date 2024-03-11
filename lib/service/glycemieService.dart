import 'dart:convert';
import 'package:http/http.dart' as http;

class GlycemieService {
  static Future<List<double>> getGlycemieData() async {
    // Définissez la clé d'API
    final apiKey = 'a8715102-5814-4ed4-bde4-c6e9e9d5bb5f';

    // Effectuez une requête HTTP pour récupérer les données de glycémie
    final response = await http.get(
      Uri.parse('https://example.com/glycemie'),
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
