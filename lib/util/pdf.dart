import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class PDFPickerPage extends StatefulWidget {
  @override
  _PDFPickerPageState createState() => _PDFPickerPageState();
}

class _PDFPickerPageState extends State<PDFPickerPage> {
  File? _pickedFile;

  Future<void> pickPDFFile() async {
    // Configuration pour sélectionner un fichier PDF
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });

      // Ici, vous pouvez utiliser _pickedFile comme vous le souhaitez
      // Par exemple, l'envoyer à une API, l'afficher, etc.
    } else {
      // Gestion de l'erreur ou de l'annulation de la sélection
      print('Aucun fichier sélectionné ou erreur de sélection.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: pickPDFFile,
            child: Text('Choisir un fichier PDF'),
          ),
          SizedBox(height: 20),
          _pickedFile != null
              ? Text('Fichier sélectionné : ${_pickedFile!.path}')
              : Text('Aucun fichier sélectionné'),
        ],
      ),
    );
  }
}
