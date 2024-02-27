import 'package:flutter/material.dart';
import 'navbar.dart';
import 'home/home.dart';
import 'user/user.dart';
import 'bolus/bolus.dart';
import 'repas/repas.dart';
import 'commandes/commandes.dart';
import 'package:url_launcher/url_launcher.dart';

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
        '/user': (context) => const UserPage(),
        '/bolus': (context) => const BolusPage(),
        '/repas': (context) => const RepasPage(),
        '/commandes': (context) => const CommandesPage(),
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
        case 0:
          _selectedPage = const UserPage(); // Afficher le contenu de user.dart
          break;
        case 1:
          _selectedPage = const BolusPage(); // Afficher le contenu de bolus.dart
          break;
        case 2:
          _selectedPage = const HomePage(); // Afficher le contenu de home.dart
          break;
        case 3:
          _selectedPage = const RepasPage(); // Afficher le contenu de repas.dart
          break;
        case 4:
          _selectedPage = const CommandesPage(); // Afficher le contenu de commandes.dart
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
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/diwe_logo.png',
          width: 150,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 85,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                color: const Color(0xFFFF914D),
              ),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    _launchEmergencyCall('tel:15'); // Appeler le numéro d'urgence
                  },
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  iconSize: 27,
                  tooltip: 'Appeler les urgences',
                ),
              ),
            ),
          ),
        ],
      ),
      // Afficher le contenu de la page sélectionnée
      body: _selectedPage,
      bottomNavigationBar: Navbar(onItemTapped: _onItemTapped),
    );
  }

  void _launchEmergencyCall(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Impossible de lancer $phoneNumber';
    }
  }
}
