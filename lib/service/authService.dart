import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:diwe_front/auth/check_mail.dart';
import 'package:diwe_front/auth/double_auth.dart';
import 'package:diwe_front/user/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity/connectivity.dart';


class ServiceException {
  final Map<String, dynamic> responseBody;

  ServiceException(this.responseBody);
}

class AuthService {


  final storage = FlutterSecureStorage();
  Future<void> login(BuildContext context, String email, String password) async {
    final String apiUrl = dotenv.get('API_HOST');
    final String apiKey = dotenv.get('API_KEY');
    print(apiKey);
      final response = await http.post(
        Uri.parse(apiUrl + "auth/login"),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': '$apiKey'
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['access_token'];
        final user = jsonDecode(response.body)['user'];

        await storage.write(key: 'jwt', value: token);
        await storage.write(key: 'user', value: jsonEncode(user));
        print(token);
        print(user);
        print(response.body);
        print('Connexion réussie');
      } else {
        print('Erreur: ${response.statusCode}');
        print('Corps de la réponse: ${response.body}');
        throw ServiceException(jsonDecode(response.body));
      }
    }

  Future<void> registerTest(String name,
      String firstname,
      String email,
      DateTime birthday,
      String phone,
      String password,
      int secretPin,
      String role,) async {
    // Stock the api url in variable
    final String apiUrl = dotenv.get('API_HOST');
    final String apiKey = dotenv.get('API_KEY');

    print(Uri.parse(apiUrl + "auth/register"));
    try {
      final response = await http.post(
        Uri.parse(apiUrl + "auth/register"),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstname': firstname,
          'role': role,
          'birthday': birthday.toIso8601String(),
          'secret_pin': secretPin,
          'lastname': name,
          'phone': phone,
        }),
      );
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }

  Future<void> resend_code(BuildContext context, String email) async {
    final String apiUrl = dotenv.get('API_HOST');
    final String apiKey = dotenv.get('API_KEY');
    print(apiKey);

    final response = await http.post(
      Uri.parse(apiUrl + "auth/resend-code"),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print('email envoyé');
      print(response.body);
    } else {
      print('Erreur: ${response.statusCode}');
      print('Corps de la réponse: ${response.body}');
      throw ServiceException(jsonDecode(response.body));
    }
  }

  Future<void> active_code(BuildContext context, String email) async {
    final String apiUrl = dotenv.get('API_HOST');
    final String apiKey = dotenv.get('API_KEY');
    print(apiKey);

    final response = await http.post(
      Uri.parse(apiUrl + "auth/resend"),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print('email envoyé');
      print(response.body);
    } else {
      print('Erreur: ${response.statusCode}');
      print('Corps de la réponse: ${response.body}');
      throw ServiceException(jsonDecode(response.body));
    }
  }

  Future<bool> isWiFiConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.wifi;
  }

  Future<Map<String, dynamic>?> getUser() async {
    final String? userJson = await storage.read(key: 'user');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  Future<bool> isLoggedIn(BuildContext context) async {
    final String? token = await getToken();
    return token != null;
  }


  Future<bool> hasAnyUserRole(List<String> roles) async {
    final Map<String, dynamic>? user = await getUser();
    if (user != null && user.containsKey('role')) {
      String userRole = user['role'];
      return roles.contains(userRole);
    }
    return false;
  }

  Future<void> verifycode(BuildContext context, String email,
      String code) async {
    final String apiUrl = dotenv.get('API_HOST');
    final String apiKey = dotenv.get('API_KEY');
    print(apiKey);

    final response = await http.post(
      Uri.parse(apiUrl + "auth/two-factor"),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'email': email,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      // Décodage du corps de la réponse
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Stockage du access_token dans le stockage sécurisé
      final String accessToken = responseBody['access_token'];
      await storage.write(key: 'jwt', value: accessToken);

      // Affichage du JWT Token pour vérification
      print('JWT Token: $accessToken'); // Ajouté pour afficher le JWT Token

      // Stockage des informations de l'utilisateur dans le stockage sécurisé
      final String userData = jsonEncode(responseBody['user']);
      await storage.write(key: 'user', value: userData);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => UserPage()),
      );

      await storage.write(key: 'jwt', value: accessToken);
      await storage.write(key: 'user', value: jsonEncode(userData));
      print(accessToken);
      print(userData);
      print(response.body);
      print('Connexion réussie');
    } else {
      print('Erreur: ${response.statusCode}');
      print('Corps de la réponse: ${response.body}');
      throw ServiceException(jsonDecode(response.body));
    }
  }

}
