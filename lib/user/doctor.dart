import 'package:diwe_front/home/Doctor.dart';
import 'package:diwe_front/service/DoctorService.dart';
import 'package:diwe_front/service/authService.dart';
import 'package:flutter/material.dart';


class DoctorListingPage extends StatefulWidget {
  @override
  _DoctorListingPageState createState() => _DoctorListingPageState();
}
class _DoctorListingPageState extends State<DoctorListingPage> {

  late DoctorService _doctorService;
  late AuthService _authservice;
  bool showEmailHistoryWidget = false;
  bool showContactForm = false;

  @override
  void initState() {
    super.initState();
    _doctorService = DoctorService();
    _authservice = AuthService();
    print(_doctorService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004396), Color(0xFF0C8CE9)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
                  Text(
                    "Professionnels",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
              Expanded( // Ajout du widget Expanded
                child: Container(
                  height: MediaQuery.of(context).size.height, // Utilisez la hauteur de l'écran par exemple
                  child: ListDoctorWidget(doctorService: _doctorService),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Rechercher un professionnel"),
                          content: DoctorSearchFormWidget(),
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
                  child: Container(
                    width: 50, // taille du cercle
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.search,
                      color: Color(0xFF004396),
                      size: 20,
                    ),
                  ),
                ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}