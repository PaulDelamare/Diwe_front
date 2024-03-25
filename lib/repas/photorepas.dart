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

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      if (widget.onImageSelected != null) {
        widget.onImageSelected!(_image!);
      }

      if (_image != null) {
        final apiKey = dotenv.env['API_KEY_FOOD_VISOR'];
        if (apiKey != null) {
          try {
            await foodvisorPost.analyzeImage(apiKey, _image!);
           // Si la réponse est bonne tu me recharge la page repas.dart
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => MyHomePage(selectedIndex: 3)),
            );


          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur lors de l\'envoi de l\'image à l\'API FoodVisor')),
            );
          }
        } else {
          print('Clé API non trouvée.');
        }
      }
    } else {
      print('Aucune image sélectionnée.');
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: getImage,
            child: Text('Choisir une photo'),
          ),
        ],
      ),
    );
  }
}
