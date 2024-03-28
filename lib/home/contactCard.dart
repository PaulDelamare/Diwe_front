import 'package:diwe_front/model/Email.dart';
import 'package:diwe_front/service/Contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io'; // Importer le package dart:io pour utiliser le type File
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Importez le widget PDFPicker ici

class ButtonRow extends StatelessWidget {
  final VoidCallback onHistoryPressed;
  final VoidCallback onComposePressed;
  final bool isComposeVisible;

  const ButtonRow({
    Key? key,
    required this.onHistoryPressed,
    required this.onComposePressed,
    required this.isComposeVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onHistoryPressed,
              child: Text('Historique'),
            ),
            SizedBox(width: 20), // Espacement entre les boutons
            ElevatedButton(
              onPressed: onComposePressed,
              child: Text('Rédigé'),
            ),
          ],
        ),
        SizedBox(height: 20), // Espacement entre les boutons et le formulaire de contact
        if (isComposeVisible) ...[
          ContactFormWidget(), // Affichage du formulaire de contact
          SizedBox(height: 20),
        ],
      ],
    );
  }
}

class ContactFormWidget extends StatefulWidget {
  @override
  _ContactFormWidgetState createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends State<ContactFormWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  List<File> _selectedFiles = [];
  final Contact contact = Contact(); // Créez une instance de Contact

  Future<void> pickPDFFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.paths.map((path) => File(path!)));
      });
    }
  }

  Future<void> _sendForm() async {
    // Supposons que `prescription` est un booléen que tu détermines ailleurs dans ton UI
    bool? prescription = true; // Placeholder pour l'exemple

    // Ici, tu appelles la méthode sendEmail de ton instance contact
    await contact.sendEmail(
      files: _selectedFiles,
      prescription: prescription,
      email: _emailController.text,
      subject: _subjectController.text,
      body: "Nom: ${_nameController.text}\nEmail: ${_emailController.text}\nSujet: ${_subjectController.text}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            SizedBox(height: 10),
            // Ajoutez vos autres champs de saisie ici...
            ElevatedButton(
              onPressed: pickPDFFiles,
              child: Text('Joindre des fichiers PDF'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Logique pour joindre une prescription
                pickPDFFiles();
              },
              child: Text('Joindre une prescription'),
            ),
            SizedBox(height: 10),
            _selectedFiles.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _selectedFiles.map((file) {
                return Text(file.path); // Affiche le chemin de chaque fichier sélectionné
              }).toList(),
            )
                : Text('Aucun fichier sélectionné'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendForm, // Appeler la fonction _sendForm lors de l'appui sur le bouton
              child: Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}


class EmailHistoryWidget extends StatefulWidget {
  @override
  _EmailHistoryWidgetState createState() => _EmailHistoryWidgetState();
}

class _EmailHistoryWidgetState extends State<EmailHistoryWidget> {
  final Contact contact = Contact(); // Créez une instance de Contact
  late Future<List<Email>> emailsFuture;

  @override
  void initState() {
    super.initState();
    // Initialiser le Future pour le chargement des e-mails
    emailsFuture = contact.getEmails();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Email>>(
      future: emailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Aucun historique d\'e-mail disponible',
              style: TextStyle(
                color: Colors.white, // Définissez la couleur du texte en blanc
              ),
            ),
          );
        } else {
          // Afficher l'historique des e-mails
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Email email = snapshot.data![index];
              return ListTile(
                leading: Icon(email.read ? Icons.mail_outline : Icons.mail),
                title: Text(email.sender),
                subtitle: Text(email.subject),
                trailing: Text(email.createdAt.toString()),
                onTap: () {
                  // Ajouter la logique pour ouvrir le détail de l'e-mail ici
                },
              );
            },
          );
        }
      },
    );
  }
}