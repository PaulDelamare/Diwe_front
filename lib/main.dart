import 'package:diwe_front/auth/Authhandler.dart';
import 'package:diwe_front/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'service/authService.dart';

void main() {
  runApp(const MyApp());
}



// Déclaration de la classe principale de l'application.
class MyApp extends StatelessWidget {
  // Constructeur de la classe MyApp.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instanciation du service d'authentification.
    final AuthService authService = AuthService();

    return MaterialApp(
      title: 'DIWE',

      theme: ThemeData(
        // Définition d'un schéma de couleurs basé sur la couleur bleue.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

        useMaterial3: true,
      ),

      home: AuthHandler(
        // Liste des rôles autorisés (utilisateur et administrateur).
        roles: ['user', 'admin','health','blog'],

        // Page à afficher lorsque l'utilisateur est connecté.
        onLoggedIn: (context) => const MyHomePage(),

        // Page à afficher lorsque l'utilisateur n'est pas connecté.
        onLoggedOut: (context) => const LoginPage(),
      ),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIWE'),
      ),
      body: Center(
        child: Text('This is the main page content'),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
