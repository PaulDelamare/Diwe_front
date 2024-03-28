import 'package:diwe_front/auth/Authhandler.dart';
import 'package:diwe_front/auth/auth_page.dart';
import 'package:diwe_front/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home/home.dart';
import 'user/user.dart';
import 'bolus/bolus.dart';
import 'repas/repas.dart';
import 'commandes/commandes.dart';
import 'navbar.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
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
      home: AuthHandler(
        roles: ['user', 'health'],
        onLoggedIn: (context) => const MyHomePage(selectedIndex: 2),
        onLoggedOut: (context) => const Authpage(),
      ),
      routes: {
        '/home': (context) => AuthHandler(
          roles: ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => const HomePage(),
          onLoggedOut: (context) => const Authpage(),
        ),
        '/user': (context) => AuthHandler(
          roles: ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => const UserPage(),
          onLoggedOut: (context) => const Authpage(),
        ),
        '/bolus': (context) => AuthHandler(
          roles: ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => const BolusPage(),
          onLoggedOut: (context) => const Authpage(),
        ),
        '/repas': (context) => AuthHandler(
          roles: ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => RepasPage(),
          onLoggedOut: (context) => const Authpage(),
        ),
        '/commandes': (context) => AuthHandler(
          roles: ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => const CommandesPage(),
          onLoggedOut: (context) => const Authpage(),
        ),
        '/settings': (context) => AuthHandler(
          roles: ['user', 'admin', 'health', 'blog'],
          onLoggedIn: (context) => const SettingPage(),
          onLoggedOut: (context) => const Authpage(),
        ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int selectedIndex;

  const MyHomePage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState(selectedIndex: selectedIndex);
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex;

  _MyHomePageState({required int selectedIndex}) {
    // Vérifiez que selectedIndex est compris entre 0 et 5
    if (selectedIndex >= 0 && selectedIndex <= 5) {
      _selectedIndex = selectedIndex;
    } else {
      throw ArgumentError('La valeur de selectedIndex doit être comprise entre 0 et 5');
    }
  }

  late Widget _selectedPage;

  @override
  void initState() {
    super.initState();
    _selectedPage = const HomePage();
  }

  @override
  Widget build(BuildContext context) {
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
        _selectedPage = RepasPage();
        break;
      case 4:
        _selectedPage = const CommandesPage();
        break;
      case 5:
        _selectedPage = const SettingPage();
        break;
      default:
        _selectedPage = HomePage();
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset(
            'assets/images/diwe_logo.png',
          ),
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
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _launchEmergencyCall(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Impossible de lancer $phoneNumber';
    }
  }
}
