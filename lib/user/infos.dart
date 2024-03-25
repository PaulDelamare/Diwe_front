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
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Text(
                  _userData?['firstname'] ?? '', // Assurez-vous que 'name' est la clé correcte
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),

                Text(
                  _userData?['lastname'] ?? '', // Assurez-vous que 'prenom' est la clé correcte
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoCard('Info 1', _userData?['info1'] ?? '...'),
                SizedBox(width: 20),
                _buildInfoCard('Info 2', _userData?['info2'] ?? '...'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoCard('Info 3', _userData?['info3'] ?? '...'),
                SizedBox(width: 20),
                _buildInfoCard('Info 4', _userData?['info4'] ?? '...'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      color: Colors.blue,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
