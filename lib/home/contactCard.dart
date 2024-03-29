import 'package:diwe_front/model/Email.dart';
import 'package:diwe_front/service/Contact.dart';
import 'package:diwe_front/user/mail.dart';
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
        SizedBox(
            height:
                20), // Espacement entre les boutons et le formulaire de contact
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
  final TextEditingController _bodyController = TextEditingController();
  List<File> _selectedFiles = [];
  final Contact contact = Contact();
  bool? _prescription; // Déclaration de la variable d'état pour la prescription

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
    bool? prescription = _prescription;

    String? result = await contact.sendEmail(
      files: _selectedFiles,
      prescription: prescription,
      email: _emailController.text,
      subject: _subjectController.text,
      body: _bodyController.text,
    );

    if (result != null) {
      // Affichez le message d'erreur dans la Snackbar en cas d'échec
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Affichez le message de succès dans la Snackbar en cas de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-mail envoyé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    }
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
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Objet'),
            ),
            TextField(
              controller: _bodyController,
              maxLines: 5,
              decoration: InputDecoration(labelText: 'Contenue'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickPDFFiles,
              child: Text('Joindre des fichiers PDF'),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Prescription'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _prescription,
                    onChanged: (value) {
                      setState(() {
                        _prescription = value;
                      });
                    },
                  ),
                  Text('Oui'),
                  Radio<bool>(
                    value: false,
                    groupValue: _prescription,
                    onChanged: (value) {
                      setState(() {
                        _prescription = value;
                      });
                    },
                  ),
                  Text('Non'),
                ],
              ),
            ),
            SizedBox(height: 10),
            _selectedFiles.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _selectedFiles.map((file) {
                      return Text(file.path);
                    }).toList(),
                  )
                : Text('Aucun fichier sélectionné'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendForm,
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
  late Future<List<Map<String, dynamic>>> emailsFuture;
  List<Map<String, dynamic>> displayedEmails = [];
  int displayedEmailsCount = 5;

  @override
  void initState() {
    super.initState();
    // Initialiser le Future pour le chargement des e-mails
    emailsFuture = contact.getEmails();
  }

  void loadMoreEmails() {
    setState(() {
      displayedEmailsCount += 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: emailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
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
          // Charger les e-mails à afficher
          displayedEmails = snapshot.data!.take(displayedEmailsCount).toList();
          // Afficher l'historique des e-mails
          return SingleChildScrollView(
            // Utiliser SingleChildScrollView ici
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Désactiver le défilement du ListView
                  itemCount: displayedEmails.length * 2 -
                      1, // Compter les espaces verticaux
                  itemBuilder: (context, index) {
                    if (index.isOdd)
                      return SizedBox(height: 16); // Espacement vertical
                    final dataIndex = index ~/ 2;
                    Map<String, dynamic> emailData = displayedEmails[dataIndex];
                    bool isEmailRead =
                        emailData['read'] ?? false; // Supposons cette propriété
                    return FractionallySizedBox(
                      widthFactor: 0.8, // 80% de la largeur du parent
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(10), // Coins arrondis
                          border: Border.all(
                            color: Color(0xFF004396), // Couleur de la bordure
                            width: 2, // Épaisseur de la bordure en pixels
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        emailData['sender'] ??
                                            'Expéditeur inconnu',
                                        style: TextStyle(
                                            color: Color(0xFF004396))),
                                    Text(
                                        'Sujet : ' +
                                            (emailData['subject'] ?? ''),
                                        style: TextStyle(
                                            color: Color(0xFF004396))),
                                  ],
                                ),
                              ),
                              // Pastille pour emails non lus
                              if (!isEmailRead) // Condition pour afficher la pastille
                                Icon(Icons.fiber_manual_record,
                                    size: 12, color: Colors.red),
                            ],
                          ),
                          onTap: () {
                            // Ajouter la logique pour ouvrir le détail de l'e-mail ici
                          },
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: loadMoreEmails,
                      icon: Icon(Icons.circle), // Icône de plus
                      label: Text('Charger plus'), // Texte du bouton
                    ),
                    SizedBox(
                        width: 20), // Espacement entre l'icône et le bouton
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactMail()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue, // Couleur du cercle
                        ),
                        padding: EdgeInsets.all(
                            8), // Espacement à l'intérieur du cercle
                        child: Icon(Icons.add,
                            color: Colors.white), // Icône de cercle
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
