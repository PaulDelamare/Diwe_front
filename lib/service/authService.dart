import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:diwe_front/auth/check_mail.dart';
import 'package:diwe_front/auth/double_auth.dart';
import 'package:diwe_front/main.dart';
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












    Future<Map<String, dynamic>?> getUser() async {
      final String? userJson = await storage.read(key: 'user');
      if (userJson != null) {
        return jsonDecode(userJson);
      }
      return null;
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



  Future<bool> isLoggedIn(BuildContext context) async {
    final String? token = await getToken();
    return token != null;
  }





  Future<void> verifycode(BuildContext context, String email, String code) async {
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
      final Map<String, dynamic> user = responseBody['user'];
      await storage.write(key: 'user', value: jsonEncode(user));

      // Stockage des propriétés de l'utilisateur dans le stockage sécurisé
      await storage.write(key: 'firstname', value: user['firstname']);
      await storage.write(key: 'lastname', value: user['lastname']);
      await storage.write(key: 'email', value: user['email']);
      await storage.write(key: 'role', value: user['role']);
      await storage.write(key: 'phone', value: user['phone']);
      await storage.write(key: 'profile_picture', value: user['profile_picture']);

      // Stockage des propriétés de last_meal dans le stockage sécurisé
      final Map<String, dynamic> lastMeal = user['last_meal'];
      await storage.write(key: 'last_meal_image_path', value: lastMeal['image_path']);
      await storage.write(key: 'last_meal_name', value: lastMeal['name']);
      await storage.write(key: 'last_meal_calories', value: lastMeal['calories'].toString());
      await storage.write(key: 'last_meal_proteins', value: lastMeal['proteins'].toString());
      await storage.write(key: 'last_meal_lipids', value: lastMeal['lipids'].toString());
      await storage.write(key: 'last_meal_glucids', value: lastMeal['glucids'].toString());
      await storage.write(key: 'last_meal_fibers', value: lastMeal['fibers'].toString());
      await storage.write(key: 'last_meal_calcium', value: lastMeal['calcium'].toString());
      await storage.write(key: 'last_meal_created_at', value: lastMeal['created_at']);

      // Stockage de secret_pin dans le stockage sécurisé
      final int secretPin = user['secret_pin'];
      await storage.write(key: 'secret_pin', value: secretPin.toString());

      // Récupération de toutes les valeurs à partir du stockage sécurisé
      final String? jwt = await storage.read(key: 'jwt');
      final String? userJson = await storage.read(key: 'user');
      final String? firstname = await storage.read(key: 'firstname');
      final String? lastname = await storage.read(key: 'lastname');
      final String? email = await storage.read(key: 'email');
      final String? role = await storage.read(key: 'role');
      final String? phone = await storage.read(key: 'phone');
      final String? profilePicture = await storage.read(key: 'profile_picture');
      final String? lastMealImagePath = await storage.read(key: 'last_meal_image_path');
      final String? lastMealName = await storage.read(key: 'last_meal_name');
      final String? lastMealCalories = await storage.read(key: 'last_meal_calories');
      final String? lastMealProteins = await storage.read(key: 'last_meal_proteins');
      final String? lastMealLipids = await storage.read(key: 'last_meal_lipids');
      final String? lastMealGlucids = await storage.read(key: 'last_meal_glucids');
      final String? lastMealFibers = await storage.read(key: 'last_meal_fibers');
      final String? lastMealCalcium = await storage.read(key: 'last_meal_calcium');
      final String? lastMealCreatedAt = await storage.read(key: 'last_meal_created_at');

// Affichage de toutes les valeurs
      print('JWT: $jwt');
      print('User: $userJson');
      print('Firstname: $firstname');
      print('Lastname: $lastname');
      print('Email: $email');
      print('Role: $role');
      print('Phone: $phone');
      print('Profile Picture: $profilePicture');
      print('Last Meal Image Path: $lastMealImagePath');
      print('Last Meal Name: $lastMealName');
      print('Last Meal Calories: $lastMealCalories');
      print('Last Meal Proteins: $lastMealProteins');
      print('Last Meal Lipids: $lastMealLipids');
      print('Last Meal Glucids: $lastMealGlucids');
      print('Last Meal Fibers: $lastMealFibers');
      print('Last Meal Calcium: $lastMealCalcium');
      print('Last Meal Created At: $lastMealCreatedAt');
      print('Secret Pin: $secretPin');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(selectedIndex: 2)),
      );

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

  Future<bool> hasAnyUserRole(List<String> roles) async {
    // Récupération du rôle de l'utilisateur à partir du stockage sécurisé
    final String? userRole = await storage.read(key: 'role');

    // Vérification si le rôle de l'utilisateur est dans la liste des rôles autorisés
    if (roles.contains(userRole)) {
      // Le rôle de l'utilisateur est dans la liste des rôles autorisés
      return true;
    } else {
      // Le rôle de l'utilisateur n'est pas dans la liste des rôles autorisés
      return false;
    }
  }


}
