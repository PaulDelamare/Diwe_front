import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GraphiqueService {
  
  static Future<double> getGlycemicChartData() async {
    final storage = FlutterSecureStorage();

    // Récupérez la clé d'API à partir du fichier .env
    final apiKey = dotenv.env['API_KEY'];
    final String? jwtToken = await storage.read(key: 'jwt');

    // Vérifiez si la clé d'API est null ou vide
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is missing or empty');
    }

    // Définissez l'URL de l'API
    final apiUrl = '${dotenv.env['API_HOST']}medicalData?limit=1'; // Remplacez "glycemie/chart" par l'URL réelle de votre API

    // Effectuez une requête HTTP pour récupérer les données du graphique glycémique
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization' : 'Bearer $jwtToken',
        'x-api-key': apiKey, // Ajoutez la clé d'API dans l'en-tête
      },
    );

    if (response.statusCode == 200) {
      // Analysez la réponse JSON
      final jsonData = json.decode(response.body);
      final pulse = jsonData['data'][0]['pulse'];

      return double.parse(pulse.toString());
    } else {
      // En cas d'erreur, lancez une exception avec le message d'erreur
      throw Exception('Failed to load glycemic chart data');
    }
  }
}
