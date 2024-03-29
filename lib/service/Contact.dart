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

  Future<String?> sendEmail({
    List<File>? files,
    bool? prescription,
    required String email,
    required String subject,
    required String body,
  }) async {
    final String apiUrl = dotenv.env['API_HOST'] ?? '';
    final String? jwtToken = await storage.read(key: 'jwt');
    final String? apiKey = dotenv.env['API_KEY'];

    if (jwtToken == null || apiKey == null) {
      throw Exception('JWT Token or API Key not found');
    }

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl + '/sendEmail'))
      ..headers['Authorization'] = 'Bearer $jwtToken'
      ..headers['x-api-key'] = apiKey;

    files?.forEach((file) async {
      String? mimeType = lookupMimeType(file.path);
      String fileExtension = mimeType?.split('/')[1] ?? '';

      List<int> fileBytes = await file.readAsBytesSync();
      request.files.add(http.MultipartFile.fromBytes(
        'files',
        fileBytes,
        filename: basename(file.path),
        contentType: MediaType('application', fileExtension),
      ));
    });

    request.fields['prescription'] = prescription?.toString() ?? 'false';
    request.fields['email'] = email;
    request.fields['subject'] = subject;
    request.fields['body'] = body;

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      // Retourne null lorsque l'envoi est réussi
      return null;
    } else {
      print('Failed to send email. Status code: ${response.statusCode}');
      print('Response from the server: $responseString');

      Map<String, dynamic> errorJson = jsonDecode(responseString);
      List<dynamic> errors = errorJson['errors'];
      String errorMessage = errors.isNotEmpty ? errors[0]['msg'] : 'Erreur inconnue';

      return errorMessage;
    }
  }



  Future<List<Map<String, dynamic>>> getEmails() async {
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
      // La demande a réussi
      List<dynamic> emailsJson = json.decode(response.body)['emails'];
      List<Map<String, dynamic>> formattedEmails = emailsJson.map<Map<String, dynamic>>((email) =>
      {
        '_id': email['_id'],
        'sender': email['sender'],
        'recipient': email['recipient'],
        'subject': email['subject'],
        'body': email['body'],
        'attachment': email['attachment'],
        'read': email['read'],
        'created_at': email['created_at'],
        '__v': email['__v'],
        // Ajoutez toutes les autres propriétés ici
      }).toList();
      return formattedEmails;
    } else {
      // Erreur lors de la demande
      print('Failed to fetch emails. Status code: ${response.statusCode}');
      final errorData = json.decode(response.body);
      print('Error from the server: $errorData');
      throw Exception('Failed to fetch emails');
    }
  }







}
