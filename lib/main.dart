import 'package:diwe_front/auth/Authhandler.dart';
import 'package:diwe_front/auth/auth_page.dart';
import 'package:diwe_front/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'home/home.dart';
import 'user/user.dart';
import 'bolus/bolus.dart';
import 'repas/repas.dart';
import 'commandes/commandes.dart';
import 'service/authService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diwe_front/util/connectivity_service.dart'; // Import du package connectivity
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async{
  //Find the .env for use it in other file
  await dotenv.load(fileName: ".env");
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
      // Utilisez AuthHandler pour gérer l'authentification et l'autorisation
      home: AuthHandler(
        roles: ['user', 'health'],
        onLoggedIn: (context) => const MyHomePage(),
        onLoggedOut: (context) => const Authpage(),
      ),
      routes: {
        '/home': (contextR) => AuthHandler(
          roles:  ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => const HomePage(),
          onLoggedOut: (context) => const Authpage(),
        ),
        '/user': (contextR) => AuthHandler(
          roles:  ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => const UserPage(),
          onLoggedOut: (context) => const Authpage(),
        ),
        '/bolus': (context) => AuthHandler(
          roles:  ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => const BolusPage(),
          onLoggedOut: (context) => const Authpage(),
        ),
        '/repas': (context) => AuthHandler(
          roles:  ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) =>  RepasPage(),
          onLoggedOut: (context) => const Authpage(),
        ),
        '/commandes': (context) => AuthHandler(
          roles:  ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => const CommandesPage(),
          onLoggedOut: (context) => const Authpage(),
        ),
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
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _selectedPage;
    switch (_selectedIndex) {
      case 0:
        _selectedPage = const UserPage();
        break;
      case 1:
        _selectedPage = const BolusPage();
        break;
      case 2:
        _selectedPage = const HomePage();
        break;
      case 3:
        _selectedPage =  RepasPage();
        break;
      case 4:
        _selectedPage = const CommandesPage();
        break;
      default:
        _selectedPage = HomePage();
    }

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
                    _launchEmergencyCall('tel:15');
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
