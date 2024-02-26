import 'package:flutter/material.dart';
import 'navbar.dart';
import 'home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIWE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/Accueil': (context) => const HomePage(),
        //'/profile': (context) => const ProfilePage(),
        //'/bolus': (context) => const BolusPage(),
        //'/repas': (context) => const RepasPage(),
        //'/commandes': (context) => const CommandesPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Variable pour stocker le contenu de la page sélectionnée
  Widget _selectedPage = Container();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Mettez à jour le contenu de la page sélectionnée en fonction de l'index
      switch (index) {
        case 2:
          _selectedPage = const HomePage(); // Afficher le contenu de home.dart
          break;
      // Ajoutez d'autres cas pour les autres pages si nécessaire
        default:
          _selectedPage = Container(); // Par défaut, afficher un conteneur vide
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Afficher le contenu de la page sélectionnée
      body: _selectedPage,
      bottomNavigationBar: Navbar(onItemTapped: _onItemTapped),
    );
  }
}