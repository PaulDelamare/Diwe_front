import 'package:diwe_front/user/doctor.dart';
import 'package:flutter/material.dart';
import 'package:diwe_front/service/authService.dart' as serviceAuth;
import 'package:diwe_front/user/doctorManager.dart' as doctorManager;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:diwe_front/service/pdfService.dart'; // Assurez-vous que le chemin est correct
import 'package:diwe_front/service/authService.dart'; // Assurez-vous que le chemin est correct

class InfosWidget extends StatefulWidget {
  @override
  _InfosWidgetState createState() => _InfosWidgetState();
}

class _InfosWidgetState extends State<InfosWidget> {
  serviceAuth.AuthService _authService = serviceAuth.AuthService();

  PdfService _pdfService = PdfService();
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

  Future<void> _updatePdf(File pdf) async {
    try {
      await _pdfService.updateOrdonnance(pdf);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Modifié avec succès')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors du chargement du pdf: $e')));
    }
  }

  Future<void> _pickAndUploadPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdf = File(result.files.single.path!);
      await _updatePdf(pdf);
    } else {
      print('Aucun fichier sélectionné');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0), // Ajoute un padding horizontal de 20
        child: Column(
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
              crossAxisSpacing: 0, // Réduit l'espacement horizontal entre les cartes
              mainAxisSpacing: 0, // Réduit l'espacement vertical entre les cartes
              childAspectRatio: 1 / 1, // Permet de contrôler le rapport hauteur/largeur des cartes
              children: [
                _buildInfoCard('',   Icon( Icons.picture_as_pdf, size: 80.0, color: Colors.white,), true),// Ajoute la taille de l'icône 
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorListingPage()),
                      );
                    },
                    child: _buildInfoCard('Info 2', Text(_userData?['info2'] ?? '...'), false),
                  ),
                _buildInfoCard('Info 3', Text(_userData?['info3'] ?? ""), false),
                _buildInfoCard('Info 4', Text(_userData?['info4'] ?? ""), false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, Widget content, bool includeUploadButton) {
  return Card(
    color: Colors.blue,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu de la colonne verticalement
        crossAxisAlignment: CrossAxisAlignment.center, // Centrer le contenu de la colonne horizontalement
        children: [
          content,
          if (includeUploadButton) // Condition pour ajouter le bouton uniquement sur la carte "Info 1"
            ElevatedButton.icon(
              onPressed: _pickAndUploadPdf,
              icon: Icon(Icons.edit),
              label: Text(
                'Modifier\nl\'ordonnance', // Ajoute un retour à la ligne
                textAlign: TextAlign.center, // Centre le texte
                style: TextStyle(fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

}
