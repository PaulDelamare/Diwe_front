import 'package:diwe_front/user/doctor.dart';
import 'package:flutter/material.dart';
import 'package:diwe_front/service/authService.dart' as serviceAuth;
import 'package:diwe_front/user/doctorManager.dart' as doctorManager;

class InfosWidget extends StatefulWidget {
  @override
  _InfosWidgetState createState() => _InfosWidgetState();
}

class _InfosWidgetState extends State<InfosWidget> {
  serviceAuth.AuthService _authService = serviceAuth.AuthService();

  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Remplacez par votre logique de récupération des données utilisateur
    Map<String, dynamic>? user = await _authService.getUser();
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
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1 / 1,
          children: [
            _buildInfoCard('Info 2', Text(_userData?['info2'] ?? '...')),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorListingPage()),
                  );
                },
                child: _buildInfoCard('Info 2', Text(_userData?['info2'] ?? '...')),
              ),
            _buildInfoCard('Info 3', Text(_userData?['info3'] ?? '...')),
            _buildInfoCard('Info 4', Text(_userData?['info4'] ?? '...')),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, Widget content) {
    return Card(
      color: Colors.blue,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            content,
          ],
        ),
      ),
    );
  }
}
