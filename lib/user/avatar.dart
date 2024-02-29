import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPage extends StatefulWidget {
  final void Function(File)? onImageSelected;

  const AvatarPage({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _AvatarPageState createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(_image!);
        }
      } else {
        print('Aucune image sélectionnée.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sélectionner une photo'),
      ),
      body: Center(
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
                    colors: [Colors.white, Colors.black],
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: _image == null
                    ? Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey[800],
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
      ),
    );
  }
}