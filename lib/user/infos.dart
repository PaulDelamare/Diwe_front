import 'package:diwe_front/service/authService.dart';
import 'package:flutter/material.dart';


class InfosWidget extends StatefulWidget {
  @override
  _InfosWidgetState createState() => _InfosWidgetState();
}

class _InfosWidgetState extends State<InfosWidget> {
  AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic>? user = await _authService.getUser();
    print(user);
    if (mounted) {
      setState(() {
        _userData = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${_userData?['firstname'] ?? ''} ${_userData?['lastname'] ?? ''}',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12), // Réduit l'espacement vertical
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 4, // Réduit l'espacement horizontal entre les cartes
          mainAxisSpacing: 4, // Réduit l'espacement vertical entre les cartes
          childAspectRatio: 1 / 1, // Permet de contrôler le rapport hauteur/largeur des cartes
          children: [
            _buildInfoCard('Info 1', _userData?['info1'] ?? '...'),
            _buildInfoCard('Info 2', _userData?['info2'] ?? '...'),
            _buildInfoCard('Info 3', _userData?['info3'] ?? '...'),
            _buildInfoCard('Info 4', _userData?['info4'] ?? '...'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      color: Colors.blue,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Réduit le rayon de la bordure
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0), // Réduit le padding intérieur de la carte
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold), // Réduit la taille de la police du titre
            ),
            SizedBox(height: 4), // Réduit l'espacement vertical entre le titre et le contenu
            Text(
              content,
              style: TextStyle(fontSize: 14, color: Colors.white), // Réduit la taille de la police du contenu
            ),
          ],
        ),
      ),
    );
  }
}
