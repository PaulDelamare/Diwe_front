import 'package:flutter/material.dart';
import 'package:diwe_front/service/authService.dart';
// Assurez-vous que ces importations correspondent à vos fichiers et widgets réels
import 'package:diwe_front/home/buttonBlog.dart';
import 'package:diwe_front/home/buttonOrdonnance.dart';
import 'package:diwe_front/home/buttonScanne.dart';
import 'package:diwe_front/bolus/boutons.dart' as Bolus;
import 'package:diwe_front/home/contactCard.dart' as Home;


// FutureBuilder<bool>(
//                         future: _authservice.hasAnyUserRole(['user']),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return CircularProgressIndicator();
//                           } else if (snapshot.hasError) {
//                             return Text('Error: ${snapshot.error}');
//                           } else if (snapshot.data == true) {
//                             return Column(
//                               children: [
//                                 Bolus.ButtonRow(
//                                   resetButtonText: 'Historique',
//                                   saveButtonText: 'Rédiger',
//                                   onResetPressed: () {
//                                     setState(() {
//                                       showContactForm = false;
//                                       showEmailHistoryWidget = true;
//                                     });
//                                   },
//                                   onSavePressed: () {
//                                     setState(() {
//                                       showContactForm = true;
//                                       showEmailHistoryWidget = false;
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 30),
//                                 // Afficher EmailHistoryWidget si showEmailHistoryWidget est vrai, sinon afficher un conteneur vide
//                                 showEmailHistoryWidget ? Home.EmailHistoryWidget() : SizedBox.shrink(),
//                                 // Afficher ContactFormWidget si showContactForm est vrai, sinon afficher un conteneur vide
//                                 showContactForm ? Home.ContactFormWidget() : SizedBox.shrink(),
//                                 Center(
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "Docteur",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                           fontSize: 20,
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       InkWell(
//                                         onTap: () {
//                                           showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return AlertDialog(
//                                                 title: Text("Ajouter un docteur"),
//                                                 content: SingleChildScrollView( // Ajout du SingleChildScrollView
//                                                   child: Column( // Envelopper le contenu dans une colonne pour une meilleure gestion
//                                                     mainAxisSize: MainAxisSize.min,
//                                                     children: <Widget>[
//                                                       DoctorFormWidget(), // Contenu de votre formulaire
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 actions: <Widget>[
//                                                   TextButton(
//                                                     child: Text('Annuler'),
//                                                     onPressed: () {
//                                                       Navigator.of(context).pop(); // Ferme le dialogue
//                                                     },
//                                                   ),
//                                                 ],
//                                               );
//                                             },
//                                           );
//                                         },
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                               padding: EdgeInsets.all(4),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.blue,
//                                                 borderRadius: BorderRadius.circular(4),
//                                               ),
//                                               child: Icon(Icons.add, color: Colors.white, size: 20),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       GestureDetector(
//                                         onTap: () {
//                                           showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return AlertDialog(
//                                                 title: Text("Rechercher un docteur"),
//                                                 content:  DoctorSearchFormWidget(),
//                                                 actions: <Widget>[
//                                                   TextButton(
//                                                     child: Text('Annuler'),
//                                                     onPressed: () {
//                                                       Navigator.of(context).pop(); // Ferme le dialogue
//                                                     },
//                                                   ),
//                                                 ],
//                                               );
//                                             },
//                                           );
//                                         },
//                                         child: Icon(
//                                           Icons.search,
//                                           color: Colors.white,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 30),
//                                 Container(
//                                   height: MediaQuery.of(context).size.height, // Utilisez la hauteur de l'écran par exemple
//                                   child: ListDoctorWidget(doctorService: _doctorService),
//                                 ),
//                               ],
//                             );
//                           } else {
//                             return SizedBox.shrink();
//                           }
//                         },
//                       ),

class UserRoleContentPage extends StatefulWidget {
  @override
  _UserRoleContentPageState createState() => _UserRoleContentPageState();
}

class _UserRoleContentPageState extends State<UserRoleContentPage> {
  late AuthService _authService; // Déclarez votre instance AuthService
  bool showEmailHistoryWidget = false;
  bool showContactForm = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(); // Initialisez votre instance AuthService
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contenu spécifique au rôle"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<bool>(
          future: _authService.hasAnyUserRole(['user']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else if (snapshot.data == true) {
              return _buildUserSpecificContent();
            } else {
              return SizedBox.shrink(); // Aucun contenu à afficher
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserSpecificContent() {
    // Construisez ici le contenu spécifique à l'utilisateur
    return Column(
      children: [
        Text("Contenu pour les utilisateurs avec le rôle 'user'"),
        // Vous pouvez réutiliser les widgets de votre HomePage ou en créer de nouveaux
        ButtonBlogCard(),
        // ButtonOrdonnanceCard(),
        ButtonScanCard(),
        // Implémentez les fonctionnalités pour ces boutons selon vos besoins
        Bolus.ButtonRow(
          resetButtonText: 'Historique',
          saveButtonText: 'Rédiger',
          onResetPressed: () => setState(() {
            showContactForm = false;
            showEmailHistoryWidget = true;
          }),
          onSavePressed: () => setState(() {
            showContactForm = true;
            showEmailHistoryWidget = false;
          }),
        ),
        showEmailHistoryWidget ? Home.EmailHistoryWidget() : SizedBox.shrink(),
        showContactForm ? Home.ContactFormWidget() : SizedBox.shrink(),
      ],
    );
  }
}
