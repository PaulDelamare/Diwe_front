import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GraphiqueService {
  static Future<List<double>> getGlycemicChartData({required bool byDay}) async {
    // Chargez les variables d'environnement à partir du fichier .env
    await dotenv.load();

    // Récupérez la clé d'API à partir du fichier .env
    final apiKey = dotenv.env['API_KEY'];

    // Vérifiez si la clé d'API est null ou vide
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is missing or empty');
    }

    // Définissez l'URL de l'API
    final apiUrl = '${dotenv.env['API_HOST']}glycemie/chart?byDay=$byDay'; // Remplacez "glycemie/chart" par l'URL réelle de votre API

    // Effectuez une requête HTTP pour récupérer les données du graphique glycémique
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'x-api-key': apiKey, // Ajoutez la clé d'API dans l'en-tête
      },
    );

    if (response.statusCode == 200) {
      // Analysez la réponse JSON
      final jsonData = json.decode(response.body);

      // Récupérez les valeurs de données du graphique et retournez-les
      final List<dynamic> data = jsonData['data'];
      final List<double> chartData = data.map<double>((dynamic item) => item['value']).toList();
      return chartData;
    } else {
      // En cas d'erreur, lancez une exception avec le message d'erreur
      throw Exception('Failed to load glycemic chart data');
    }
  }
}
