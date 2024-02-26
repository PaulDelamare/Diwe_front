import 'package:flutter/material.dart';
import 'navbar.dart'; // Importez votre Navbar ici
import 'home/home.dart'; // Importez votre home.dart ici

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
        // Ajoutez d'autres routes pour les autres pages ici
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    switch (_selectedIndex) {
      case 0:
        bodyWidget = HomePage(); // Afficher le contenu de home.dart
        break;
    // Ajoutez d'autres cas pour les autres pages si nécessaire
      default:
        bodyWidget = Container(); // Par défaut, afficher un conteneur vide
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('DIWE'),
      ),
      body: bodyWidget, // Afficher le contenu de la page correspondante
      bottomNavigationBar: Navbar(), // Utilisez votre Navbar ici
    );
  }
}
