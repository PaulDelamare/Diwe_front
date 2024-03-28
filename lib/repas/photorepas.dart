import 'dart:io';
import 'package:diwe_front/main.dart';
import 'package:diwe_front/repas/repas.dart';
import 'package:diwe_front/service/repasService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Photorepas extends StatefulWidget {
  final void Function(File)? onImageSelected;

  const Photorepas({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _PhotoRepasPageState createState() => _PhotoRepasPageState();
}

class _PhotoRepasPageState  extends State<Photorepas> {
  File? _image;
  final foodvisorPost = FoodVisorPost();
  final apiKey = dotenv.env['API_KEY_FOOD_VISOR'];

  final picker = ImagePicker();

// Fonction pour récupérer une image à partir de la galerie
  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery); // Sélectionne une image depuis la galerie

    if (pickedFile != null) { // Vérifie si une image a été sélectionnée
      setState(() {
        _image = File(pickedFile.path); // Met à jour l'état avec le fichier de l'image sélectionnée
      });

      if (widget.onImageSelected != null) { // Vérifie si une fonction de sélection d'image est fournie
        widget.onImageSelected!(_image!); // Appelle la fonction de sélection d'image avec le fichier de l'image sélectionnée
      }

      if (_image != null) { // Vérifie si un fichier d'image existe
        final apiKey = dotenv.env['API_KEY_FOOD_VISOR']; // Récupère la clé API de FoodVisor depuis le fichier .env
        if (apiKey != null) { // Vérifie si la clé API est présente
          try {
            await foodvisorPost.analyzeImage(apiKey, _image!); // Analyse l'image avec l'API FoodVisor

            // Si l'analyse de l'image est réussie, recharge la page Repas
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => MyHomePage(selectedIndex: 3)),
            );
          } catch (e) { // En cas d'erreur lors de l'analyse de l'image
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur lors de l\'envoi de l\'image à l\'API FoodVisor')), // Affiche un message d'erreur dans un SnackBar
            );
          }
        } else { // Si la clé API n'est pas trouvée
          print('Clé API non trouvée.'); // Affiche un message dans la console
        }
      }
    } else { // Si aucune image n'a été sélectionnée
      print('Aucune image sélectionnée.'); // Affiche un message dans la console
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: getImage,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF004396), Color(0xFF0C8CE9)],
                ),
                border: Border.all(
                  color: Colors.transparent,
                  width: 3,
                ),
              ),
              child: _image == null
                  ? Image.asset(
                'assets/images/camera.png', // Chemin vers l'image par défaut
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
                  : ClipOval(
                child: Image.file(
                  _image!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
