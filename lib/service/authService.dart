import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServiceException {
  final Map<String, dynamic> responseBody;

  ServiceException(this.responseBody);
}

class AuthService {
  final storage = FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    //Stock the api url in variable
    final String apiUrl = dotenv.get('API_HOST');

    final response = await http.post(
      Uri.parse(apiUrl + "auth/login"),
      headers: {
        'Content-Type': 'application/json',
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

      print('Connexion réussie');
    } else {
      print('Erreur: ${response.statusCode}');
      print('Corps de la réponse: ${response.body}');
      throw ServiceException(jsonDecode(response.body));
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  Future<Map<String, dynamic>?> getUser() async {
    final String? userJson = await storage.read(key: 'user');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
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




  Future<void> register(String name, String firstname, String email, DateTime birthday, String phone, String password, int secretPin, String role ) async {
    //Stock the api url in variable
    final String apiUrl = dotenv.get('API_HOST');


    final response = await http.post(
      Uri.parse(apiUrl + "auth/register"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'firstname': firstname,
        'role': role,
        'birthday': birthday,
        'secret_pin': secretPin,
        'lastname': name,
        'phone': phone
      }),
    );
    if (response.statusCode == 200) {
      print('Incsription réussie');
    } else {
      print('Erreur: ${response.statusCode}');
      print('Corps de la réponse: ${response.body}');
      throw ServiceException(jsonDecode(response.body));
    }
  }

}
