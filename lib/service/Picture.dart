import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Picture {
  final storage = FlutterSecureStorage();

  Future<void> updateProfilePicture(File imageFile) async {
    final String apiUrl = dotenv.get('API_HOST');

    final String? jwtToken = await storage.read(key: 'jwt');


    // Création du formulaire pour envoyer les données
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl + 'user/update-profile-picture'));
    final String apikey = dotenv.get('API_KEY');

    // Ajout du token JWT et de l'API key dans les en-têtes
    request.headers['Authorization'] = 'Bearer $jwtToken';
    request.headers['x-api-key'] = apikey;

    // Ajout de l'image au formulaire
    request.files.add(
      http.MultipartFile(
        'image',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split('/').last,
      ),
    );

    // Envoi de la requête et gestion de la réponse
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Profile picture updated successfully.');
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
    }
  }
}
