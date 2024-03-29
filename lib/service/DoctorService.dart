import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DoctorService {
  final storage = FlutterSecureStorage();

  Future<void> createDoctor(String email, String firstname, {String? lastname, String? phone}) async {
    final String apiUrl = dotenv.get('API_HOST');

    final String? jwtToken = await storage.read(key: 'jwt');
    String? apiKey = dotenv.env['API_KEY'];
    if (jwtToken == null || apiKey == null) {
      throw Exception('JWT Token or API Key not found');
    }

    var request = http.Request('POST', Uri.parse(apiUrl + 'user/doctor'));

    request.headers['Authorization'] = 'Bearer $jwtToken';
    request.headers['x-api-key'] = apiKey;
    request.headers['Content-Type'] = 'application/json';

    Map<String, dynamic> body = {
      'email': email,
      'firstname': firstname,
    };

    if (lastname != null) body['lastname'] = lastname;
    if (phone != null) body['phone'] = phone;

    request.body = jsonEncode(body);

    var response = await http.Client().send(request);
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      // Doctor created successfully
      print('Doctor created successfully.');
      print(responseBody);
      return; // Rien à retourner en cas de succès
    } else {
      // Erreur lors de la création du docteur, renvoie l'erreur
      Map<String, dynamic> decodedResponseBody = jsonDecode(responseBody);
      if (decodedResponseBody.containsKey('errors')) {
        // Extraire le message d'erreur de la réponse de l'API
        String errorMessage = decodedResponseBody['errors'][0]['msg'];
        throw Exception(errorMessage);
        print(responseBody);
      } else {
        throw Exception('Failed to create doctor');
      }
    }
  }


  Future<Map<String, dynamic>> findDoctor(String email) async {
    final String apiUrl = dotenv.get('API_HOST');

    final String? jwtToken = await storage.read(key: 'jwt');
    String? apiKey = dotenv.env['API_KEY'];
    if (jwtToken == null || apiKey == null) {
      throw Exception('JWT Token or API Key not found');
    }

    var url = Uri.parse('$apiUrl/user/find-doctor?email=$email');

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      // Médecin trouvé avec succès
      print(response.body);
      return json.decode(response.body);
    } else {
      // Erreur lors de la recherche du médecin
      String errorMessage;
      try {
        Map<String, dynamic> decodedResponseBody = jsonDecode(response.body);
        if (decodedResponseBody.containsKey('errors')) {
          // Extraire le message d'erreur de la réponse de l'API
          errorMessage = decodedResponseBody['errors'][0]['msg'];
        } else {
          errorMessage = 'Failed to find doctor: ${response.statusCode}';
        }
      } catch (e) {
        errorMessage = 'Failed to find doctor: ${response.statusCode}';
      }
      throw Exception(errorMessage);
    }
  }


  Future<void> requestLinkToDoctor(String doctorId) async {
    final String apiUrl = dotenv.get('API_HOST');

    final String? jwtToken = await storage.read(key: 'jwt');
    final String? apiKey = dotenv.env['API_KEY'];
    if (jwtToken == null) {
      throw Exception('JWT Token not found');
    }
    if (apiKey == null) {
      throw Exception('API Key not found');
    }

    final String url = '$apiUrl/user/request-link?id=$doctorId';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // La demande a réussi
      print('Link request sent successfully.');
      print(json.decode(response.body));
    } else {
      // Erreur lors de la demande
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to send link request');
    }
  }

  Future<List<Map<String, dynamic>>> getRequestLinkToDoctor() async {
    final String apiUrl = dotenv.get('API_HOST');
    final String? jwtToken = await storage.read(key: 'jwt');
    final String? apiKey = dotenv.env['API_KEY'];

    if (jwtToken == null) {
      throw Exception('JWT Token not found');
    }

    if (apiKey == null) {
      throw Exception('API Key not found');
    }

    final String url = '$apiUrl/doctor/users';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
        'x-api-key': apiKey
      },
    );

    if (response.statusCode == 200) {
      // La demande a réussi
      List<dynamic> users = json.decode(response.body)['users'];
      List<Map<String, dynamic>> formattedUsers = users.map<Map<String, dynamic>>((user) =>
      {
        'firstname': user['firstname'],
        'lastname': user['lastname'],
        'email': user['email'],
        'phone': user['phone'],
      }).toList();
      return formattedUsers;
    } else if (response.statusCode == 403) {
      // Erreur lors de la demande
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to get user data');
    } else {
      // Autres cas d'erreur, retourne une liste vide
      return [];
    }
  }

  Future<List<Map<String, dynamic>>?> getLinkedDoctors() async {
    final String apiUrl =  'http://2bci.portfolio-etudiant-rouen.com:30000/api/' ;
    final String? jwtToken = await storage.read(key: 'jwt');
    final String? apiKey = dotenv.env['API_KEY'];
    print(apiUrl);

    if (jwtToken == null || apiKey == null) {
      throw Exception('JWT Token or API Key not found');
    }

    final response = await http.get(
      Uri.parse(apiUrl + 'user/doctor'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> doctors = responseData['doctors'];
      List<Map<String, dynamic>> linkedDoctors = doctors.cast<Map<String, dynamic>>();
      return linkedDoctors;
    } else {
      throw Exception('Failed to load linked doctors: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>?> getRequestLinkToDoctorDetails() async {
    final String apiUrl = dotenv.get('API_HOST');
    final String? apiKey = dotenv.env['API_KEY'];


    final String? jwtToken = await storage.read(key: 'jwt');
    if (jwtToken == null || apiKey == null) {
      throw Exception('JWT Token or API Key not found');
    }
    final response = await http.get(Uri.parse('$apiUrl/user/request'), headers: {
      'Authorization': 'Bearer $jwtToken',
      'x-api-key': apiKey,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> requests = List.from(jsonResponse['requests']);
      return requests;
    } else {
      throw Exception('Failed to load request link to doctor: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>?> getDoctorLinked() async {
    final String apiUrl = dotenv.get('API_HOST');
    final String? apiKey = dotenv.env['API_KEY'];


    final String? jwtToken = await storage.read(key: 'jwt');
    if (jwtToken == null || apiKey == null) {
      throw Exception('JWT Token or API Key not found');
    }

    final response = await http.get(Uri.parse('$apiUrl/user/doctor'), headers: {
      'Authorization': 'Bearer $jwtToken',
      'x-api-key': apiKey,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> doctors = List.from(jsonResponse['doctors']);
      return doctors;
    } else {
      throw Exception('Failed to load linked doctors: ${response.statusCode}');
    }
  }

}
