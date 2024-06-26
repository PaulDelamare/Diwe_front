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
import 'package:diwe_front/bolus/boutons.dart'
    as Bolus; // Alias pour les boutons de bolus
import 'package:diwe_front/home/contactCard.dart'
    as Home; // Alias pour le formulaire de contact

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DoctorService _doctorService;
  late AuthService _authservice; // Déclarez votre instance DoctorService
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
          child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: IntrinsicHeight(
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
                    SizedBox(height: 25),
                    GlycemicChart(),
                    SizedBox(height: 25),
                    ButtonBlogCard(),
                    // ButtonOrdonnanceCard(),
                    ButtonScanCard(),
                    DownloadOrdonnancePage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
