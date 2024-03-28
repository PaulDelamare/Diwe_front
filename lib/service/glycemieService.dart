import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GlycemieService {
  static Future<List<double>> getGlycemieData() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? jwtToken = await storage.read(key: 'jwt');

    await dotenv.load();

    final apiKey = dotenv.env['API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is missing or empty');
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['API_HOST']}medicalData?limit=1&id=65e5d15b1f639b791a2c20fc'), // Utilisez la variable API_HOST du .env
      headers: {
        'x-api-key': apiKey,
        'Authorization': 'Bearer $jwtToken'
      },
    );

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);
      final double mmolLValue = (jsonData['data'][0]["pulse"] as num).toDouble();
      final double mgdlValue = (jsonData['data'][0]["pulse"] as num).toDouble();
      return [mmolLValue, mgdlValue];
    } else {
      throw Exception('Failed to load glycemie data');
    }
  }
}
