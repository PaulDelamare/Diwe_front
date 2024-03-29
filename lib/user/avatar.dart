import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:diwe_front/service/Picture.dart';

class AvatarPage extends StatefulWidget {
  final void Function()? onImageUpdated;

  const AvatarPage({Key? key, this.onImageUpdated}) : super(key: key);

  @override
  _AvatarPageState createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  File? _image;
  final storage = FlutterSecureStorage();
  final picker = ImagePicker();
  final Picture _picture = Picture();
  late String _baseUrl;
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    _baseUrl = dotenv.get('URL_IMAGE') ?? '';
    _loadProfilePicture();
  }

  Future<void> _loadProfilePicture() async {
    final String? picture = await storage.read(key: 'profile_picture');

    if (picture != null) {
      setState(() {
        _profilePicture = picture;
        _image = File('$_baseUrl$_profilePicture');
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (widget.onImageUpdated != null) {
          widget.onImageUpdated!();
        }
        _updateProfilePicture(_image!);
      } else {
        print('Aucune image sélectionnée.');
      }
    });
  }

  void _updateProfilePicture(File imageFile) async {
    try {
      await _picture.updateProfilePicture(imageFile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image de profil mise à jour avec succès.'),
          backgroundColor: Colors.green,
        ),
      );

      // Recharger le widget après la mise à jour de l'image de profil
      _loadProfilePicture();
    } catch (error) {
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
                'assets/images/profile.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
                  : ClipOval(
                child: Image.network(
                  '$_baseUrl$_profilePicture',
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
