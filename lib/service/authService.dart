// Importation des bibliothèques nécessaires pour les fonctionnalités d'authentification.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Définition de la classe AuthService pour gérer les fonctionnalités d'authentification.
class AuthService {
  // Instance de FlutterSecureStorage pour stocker de manière sécurisée les informations de l'utilisateur.
  final storage = FlutterSecureStorage();

  // Fonction de connexion à l'aide d'une adresse e-mail et d'un mot de passe.
  Future<void> login(String email, String password) async {
    // Chargement des variables d'environnement à partir du fichier .env.
    await dotenv.load();

    // Récupération de l'URL d'API à partir des variables d'environnement.
    final String apiUrl = dotenv.get('API_LOGIN');

    // Envoi d'une requête HTTP de type POST pour l'authentification.
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    // Vérification de la réponse du serveur.
    if (response.statusCode == 200) {
      // Extraction du jeton d'accès et des informations utilisateur à partir de la réponse.
      final token = jsonDecode(response.body)['access_token'];
      final user = jsonDecode(response.body)['user'];

      // Stockage du jeton d'accès et des informations utilisateur de manière sécurisée.
      await storage.write(key: 'jwt', value: token);
      await storage.write(key: 'user', value: jsonEncode(user));

      // Affichage d'un message indiquant que la connexion a réussi.
      print('Connexion réussie');
    } else {
      // Affichage d'un message d'erreur en cas d'échec de la connexion.
      print('Erreur: ${response.statusCode}');
      print('Corps de la réponse: ${response.body}');
    }
  }

  // Fonction pour récupérer le jeton d'accès stocké.
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  // Fonction pour récupérer les informations de l'utilisateur stockées.
  Future<Map<String, dynamic>?> getUser() async {
    final String? userJson = await storage.read(key: 'user');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  // Fonction pour vérifier si l'utilisateur est actuellement connecté.
  Future<bool> isLoggedIn(BuildContext context) async {
    final String? token = await getToken();
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  // Fonction pour vérifier si l'utilisateur a l'un des rôles spécifiés.
  Future<bool> hasAnyUserRole(List<String> roles) async {
    final Map<String, dynamic>? user = await getUser();
    if (user != null && user.containsKey('role')) {
      String userRole = user['role'];
      return roles.contains(userRole);
    }
    return false;
  }
}
