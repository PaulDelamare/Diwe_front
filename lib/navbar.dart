import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex; // Ajoutez cette propriété pour indiquer l'élément sélectionné

  const Navbar({Key? key, required this.onItemTapped, required this.selectedIndex}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  static const List<String> _labels = [
    'user',
    'bolus',
    'home',
    'repas',
    'commandes',
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF8F8F8),
      selectedItemColor: const Color(0xFF0C8CE9),
      unselectedItemColor: const Color(0xFF004396),
      currentIndex: widget.selectedIndex, // Utilisez la propriété selectedIndex passée par le parent
      onTap: (index) {
        widget.onItemTapped(index); // Utiliser la fonction fournie par le widget parent
      },
      items: List.generate(
        _labels.length,
            (index) => BottomNavigationBarItem(
          icon: SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/images/${_labels[index].toLowerCase()}.png', // Utilisez le nom de l'icône correspondant à l'élément
            ),
          ),
          label: _labels[index],
        ),
      ),
    );
  }
}
