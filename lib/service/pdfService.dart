import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';


class ServiceException {
  final Map<String, dynamic> responseBody;

  ServiceException(this.responseBody);
}

class pdfService {

  static Future<void> downloadOrdonnance(BuildContext context) async {
    final String apiUrl = dotenv.get('API_HOST');
    String? apiKey = dotenv.env['X_API_KEY'];
    final FlutterSecureStorage storage = FlutterSecureStorage();

    try {
      String? jwtToken = await storage.read(key: 'jwt');
      if (jwtToken == null) {
        throw Exception('JWT Token not found');
      }
      final response = await http.get(

        Uri.parse(apiUrl + 'user/prescription'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': '$apiKey',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        print('object');
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/ordonnance.pdf');
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ordonnance téléchargée avec succès'),
          backgroundColor: Colors.green,
        ));
      } else {
        print(response.body);

        throw Exception('Erreur lors du téléchargement de l\'ordonnance');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors du téléchargement de l\'ordonnance'),
        backgroundColor: Colors.red,
      ));
    }
  }


  Future<void> updateOrdonnance(File pdfFile) async {
    //Stock the api url in variable
    final String apiUrl = dotenv.env['API_HOST']!;
    final String? apiKey = dotenv.env['X_API_KEY'];
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? jwtToken = await storage.read(key: 'jwt');

    if (jwtToken == null) {
      print('JWT Token not found');
      return;
    }

    try {
      // Créer une requête multipart
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrl + 'user/prescription'));
      request.files.add(await http.MultipartFile.fromPath(
          'uploads', // Ce nom doit correspondre exactement à celui attendu par Multer sur le serveur
          pdfFile.path,
          contentType: MediaType('application', 'pdf')
      ));
      request.headers.addAll({'x-api-key': "$apiKey"});

      // Envoyer la requête
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Ordonnance modifiée avec succès');
      } else {
        print('Erreur lors de la modification de l\'ordonnance');
        // Il est utile d'obtenir le corps de la réponse en cas d'erreur pour le débogage
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }


}
