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
    _authservice = AuthService();// Initialisez votre instance DoctorService
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child:  Column(
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
                      ButtonOrdonnanceCard(),
                      ButtonScanCard(),
                      SizedBox(height: 30),
                      // Affichez que si le il a le role user

                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
