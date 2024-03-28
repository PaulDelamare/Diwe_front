import 'dart:convert';
import 'dart:io';
import 'package:diwe_front/model/Email.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart'; // Assurez-vous d'inclure cette bibliothèque pour MediaType
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class Contact {
  final storage = FlutterSecureStorage();

  Future<void> sendEmail({
    List<File>? files,
    bool? prescription,
    required String email,
    required String subject,
    required String body,
  }) async {
    final String apiUrl = dotenv.env['API_HOST'] ?? ''; // Remplacer par votre URL d'API
    final String? jwtToken = await storage.read(key: 'jwt');
    final String? apiKey = dotenv.env['API_KEY'];

    if (jwtToken == null || apiKey == null) {
      throw Exception('JWT Token or API Key not found');
    }

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl + '/sendEmail'))
      ..headers['Authorization'] = 'Bearer $jwtToken'
      ..headers['x-api-key'] = apiKey;

    // Ajouter des fichiers s'ils existent
    files?.forEach((file) async {
      String? mimeType = lookupMimeType(file.path);
      String fileExtension = mimeType?.split('/')[1] ?? '';

      List<int> fileBytes = await file.readAsBytesSync();
      request.files.add(http.MultipartFile.fromBytes(
          'files',
          fileBytes,
          filename: basename(file.path),
          contentType: MediaType('application', fileExtension) // Assurez-vous que cela correspond au type MIME attendu par votre serveur
      ));
    });

    // Ajout des champs de formulaire
    request.fields['prescription'] = prescription?.toString() ?? 'false';
    request.fields['email'] = email;
    request.fields['subject'] = subject;
    request.fields['body'] = body;

    // Envoi de la requête
    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('Email sent successfully.');
      print(responseString);
    } else {
      print('Failed to send email. Status code: ${response.statusCode}');
      print('Response from the server: $responseString');
    }
  }


  Future<List<Email>> getEmails() async {
    final String apiUrl = 'http://10.0.2.2:3000/api/';
    final String? jwtToken = await storage.read(key: 'jwt');
    final String? apiKey = dotenv.env['API_KEY'];

    if (jwtToken == null || apiKey == null) {
      throw Exception('JWT Token or API Key not found');
    }

    final Uri url = Uri.parse('$apiUrl/email');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> emailsJson = body['emails'];
      if (emailsJson.isNotEmpty) {
        final List<Email> emails = emailsJson.map((e) => Email.fromJson(e as Map<String, dynamic>)).toList();
        return emails;
      } else {
        // Ici tu pourrais soit retourner une liste vide, soit lancer une exception personnalisée
        print('Aucun historique d\'email');
        return []; // Retourne une liste vide puisqu'il n'y a pas d'e-mails
      }
    } else {
      print('Failed to fetch emails. Status code: ${response.statusCode}');
      final errorData = jsonDecode(response.body);
      print('Error from the server: $errorData');
      throw Exception('Failed to fetch emails');
    }
  }




}
