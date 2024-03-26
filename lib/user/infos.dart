import 'dart:io';
import 'package:diwe_front/service/pdfService.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:diwe_front/service/authService.dart';

class InfosWidget extends StatefulWidget {
  @override
  _InfosWidgetState createState() => _InfosWidgetState();
}

class _InfosWidgetState extends State<InfosWidget> {
  AuthService _authService = AuthService();
  pdfService _pdfService = pdfService();
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

  Future<void> _updatePdf(File pdf) async{
    try{
      await _pdfService.updateOrdonnance(pdf);
      print('Telecharger avec succes');
    }catch(e){
      print('Erreur lors du telechargement');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10.0),
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
                  _userData?['firstname'] ?? '',
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(
                  _userData?['lastname'] ?? '',
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoCard('Info 1', Text(('...'))),
                SizedBox(width: 20),
                _buildInfoCard('Info 2', Text('...')),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoCard('Info 3', Text('...')),
                SizedBox(width: 20),
                _buildInfoCard('Ordonnance', ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      await _updatePdf(file);
                    } else {
                      // L'utilisateur a annulé le choix de fichier
                      print("Aucun fichier sélectionné");
                    }
                  },
                  child: Text('Choisir un fichier PDF'),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, Widget content) {
    return Card(
      color: Colors.blue,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            content
          ],
        ),
      ),
    );
  }
}
