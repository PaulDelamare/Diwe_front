import 'package:diwe_front/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:diwe_front/home/Doctor.dart';
import 'package:diwe_front/home/Profile.dart';
import 'package:diwe_front/service/DoctorService.dart';
import 'glycemie.dart';
import 'graphique.dart';
import 'buttonBlog.dart';
import 'buttonOrdonnance.dart';
import 'buttonScanne.dart';
import 'package:diwe_front/bolus/boutons.dart' as Bolus; // Alias pour les boutons de bolus
import 'package:diwe_front/home/contactCard.dart' as Home; // Alias pour le formulaire de contact

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DoctorService _doctorService;
  late AuthService _authservice;// Déclarez votre instance DoctorService
  String? _selectedUnit = 'mmol/L';
  bool showEmailHistoryWidget = false;
  bool showContactForm = false;

  @override
  void initState() {
    super.initState();
    _doctorService = DoctorService();
    _authservice = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GlycemieCircle(
              selectedUnit: _selectedUnit,
              onUnitChanged: (newValue) {
                setState(() {
                  _selectedUnit = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF0C8CE9),
                      radius: 30,
                      child: Icon(
                        Icons.mail,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Espacement entre les icônes
                // Icône de recherche
              ],
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF004396), Color(0xFF0C8CE9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 5),
                  GlycemicChart(),
                  SizedBox(height: 25),
                  ButtonBlogCard(),
                  DownloadOrdonnancePage(),
                  ButtonScanCard(),
                  SizedBox(height: 30),
                  // Affichez que si le il a le role user
                  FutureBuilder<bool>(
                    future: _authservice.hasAnyUserRole(['user']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.data == true) {
                        return Column(
                          children: [
                            Bolus.ButtonRow(
                              resetButtonText: 'Historique',
                              saveButtonText: 'Rédiger',
                              onResetPressed: () {
                                setState(() {
                                  showContactForm = false;
                                  showEmailHistoryWidget = true;
                                });
                              },
                              onSavePressed: () {
                                setState(() {
                                  showContactForm = true;
                                  showEmailHistoryWidget = false;
                                });
                              },
                            ),
                            SizedBox(height: 30),
                            // Afficher EmailHistoryWidget si showEmailHistoryWidget est vrai, sinon afficher un conteneur vide
                            showEmailHistoryWidget ? Home.EmailHistoryWidget() : SizedBox.shrink(),
                            // Afficher ContactFormWidget si showContactForm est vrai, sinon afficher un conteneur vide
                            showContactForm ? Home.ContactFormWidget() : SizedBox.shrink(),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Docteur",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Ajouter un docteur"),
                                            content: SingleChildScrollView( // Ajout du SingleChildScrollView
                                              child: Column( // Envelopper le contenu dans une colonne pour une meilleure gestion
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  DoctorFormWidget(), // Contenu de votre formulaire
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Annuler'),
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Ferme le dialogue
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Icon(Icons.add, color: Colors.white, size: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Rechercher un docteur"),
                                            content:  DoctorSearchFormWidget(),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Annuler'),
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Ferme le dialogue
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              height: MediaQuery.of(context).size.height, // Utilisez la hauteur de l'écran par exemple
                              child: ListDoctorWidget(doctorService: _doctorService),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
