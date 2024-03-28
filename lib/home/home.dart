import 'package:flutter/material.dart';
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
  String? _selectedUnit = 'mmol/L';
  bool showEmailHistoryWidget = false;
  bool showContactForm = false;

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
                  ButtonOrdonnanceCard(),
                  ButtonScanCard(),
                  SizedBox(height: 30),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
