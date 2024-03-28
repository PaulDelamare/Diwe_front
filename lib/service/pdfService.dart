import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';



class ServiceException {
  final Map<String, dynamic> responseBody;

  ServiceException(this.responseBody);
}

class PdfService {

  static Future<void> downloadOrdonnance(BuildContext context) async {
    // URL de l'API et headers
    final String apiUrl = dotenv.env['API_HOST']!;
    final String? apiKey = dotenv.env['API_KEY'];
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? jwtToken = await storage.read(key: 'jwt');

    // Demander la permission de stockage
    var status = await Permission.photos.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission de stockage refusée'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      // Exécuter la requête GET
      final response = await http.get(
        Uri.parse(apiUrl+'user/prescription'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': "$apiKey",
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        // Trouver un emplacement pour sauvegarder le fichier
        final directory = await getDownloadsDirectory();
        print(directory);
        if (directory != null) {
            final filePath = '${directory.path}/ordonnance.pdf';
            final file = File(filePath);
            // Écrire les bytes du PDF dans le fichier
            await file.writeAsBytes(response.bodyBytes);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Ordonnance téléchargée avec succès.'),
              backgroundColor: Colors.green,
            ));
        } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Impossible de trouver le répertoire de téléchargements.'),
              backgroundColor: Colors.red,
            ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors du téléchargement de l\'ordonnance.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors du téléchargement de l\'ordonnance: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }


  Future<void> updateOrdonnance(File pdfFile) async {
    //Stock the api url in variable
    final String apiUrl = dotenv.env['API_HOST']!;
    final String? apiKey = dotenv.env['API_KEY'];
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? jwtToken = await storage.read(key: 'jwt');

    if (jwtToken == null) {
      print('JWT Token not found');
      return;
    }
    print(pdfFile.path);
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrl + '/user/prescription'));
      request.files.add(await http.MultipartFile.fromPath(
          'prescription',
          pdfFile.path,
          contentType: MediaType('application', 'pdf')
      ));
      request.headers.addAll({'x-api-key': "$apiKey",'Authorization': 'Bearer $jwtToken'});
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print('Statut de la réponse: ${response.statusCode}');
      print('Corps de la réponse: $responseString');
      if (response.statusCode == 200) {
        print('Ordonnance modifiée avec succès');
      } else {
        print('Erreur lors de la modification de l\'ordonnance');
        print('Détail de l\'erreur: $responseString');

      }
    } catch (e) {
      print(e.toString());
    }
  }


}
