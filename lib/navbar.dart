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
    'settings'
  ];

  @override
  Widget build(BuildContext context) {
    final int itemCount = _labels.length > 4 ? 4 : _labels.length;

    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF8F8F8),
      selectedItemColor: const Color(0xFF0C8CE9),
      unselectedItemColor: const Color(0xFF004396),
      currentIndex: widget.selectedIndex >= itemCount ? 0 : widget.selectedIndex, // Assurez-vous que currentIndex est dans les limites valides
      onTap: (index) {
        widget.onItemTapped(index); // Utiliser la fonction fournie par le widget parent
      },
      items: List.generate(
        itemCount, // Utilisez les quatre premiers labels ou tous les labels s'il y en a moins de quatre
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
