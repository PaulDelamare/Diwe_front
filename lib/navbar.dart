import 'package:diwe_front/auth/auth_page.dart';
import 'package:diwe_front/home/home.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final Function(int) onItemTapped;

  const Navbar({Key? key, required this.onItemTapped}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}


class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  static const List<String> _assetPaths = [
    'assets/images/user.png',
    'assets/images/bolus.png',
    'assets/images/home.png',
    'assets/images/repas.png',
    'assets/images/commandes.png',
  ];

  static const List<String> _labels = [
    'Profile',
    'Bolus',
    'Accueil',
    'Repas',
    'Commandes',
  ];


  //pour faire la navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Authpage()),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF8F8F8),
      selectedItemColor: const Color(0xFF0C8CE9),
      unselectedItemColor: const Color(0xFF004396),
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onItemTapped(index); // Utiliser la fonction fournie par le widget parent
      },
      items: List.generate(
        _assetPaths.length,
            (index) => BottomNavigationBarItem(
          icon: SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(_assetPaths[index]),
          ),
          label: _labels[index],
        ),
      ),
    );
  }
}
