import 'dart:io';
import 'package:diwe_front/service/Picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AvatarPage extends StatefulWidget {
  final void Function(File)? onImageSelected;

  const AvatarPage({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _AvatarPageState createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  File? _image;
  final storage = FlutterSecureStorage();
  final picker = ImagePicker();
  final Picture _picture = Picture(); // Instancier la classe Picture
  late String _baseUrl;
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
    _baseUrl = dotenv.get('URL_IMAGE') ?? '';
  }

  Future<void> _loadProfilePicture() async {
    _profilePicture = await storage.read(key: 'profile_picture');

    if (_profilePicture != null) {
      setState(() {
        _image = File('$_baseUrl$_profilePicture');
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(_image!);
        }

        // Appeler la méthode updateProfilePicture lorsque l'image est sélectionnée
        _updateProfilePicture(_image!);
      } else {
        print('Aucune image sélectionnée.');
      }
    });
  }

  // Méthode pour appeler la mise à jour de l'image de profil via l'API
  void _updateProfilePicture(File imageFile) async {
    try {
      // Appeler la méthode updateProfilePicture de la classe Picture
      await _picture.updateProfilePicture(imageFile);

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image de profil mise à jour avec succès.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Afficher un message d'erreur en cas d'échec de la mise à jour
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour de l\'image de profil: $error'),
          backgroundColor: Colors.red,
        ),
      );
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
                'assets/images/profile.png', // Chemin vers l'image par défaut
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
                  : ClipOval(
                child: Image.network(
                  '$_baseUrl$_profilePicture', // Utiliser Image.network avec l'URL de l'image
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
