import 'package:diwe_front/home/contactCard.dart';
import 'package:flutter/material.dart';

class HistoryMail extends StatefulWidget {
  @override
  _HistoryMailState createState() => _HistoryMailState();
}

class _HistoryMailState extends State<HistoryMail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des e-mails'),
      ),
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
                "Historique des e-mails",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              // Ajoutez ici votre widget pour afficher l'historique des e-mails
              Expanded(
                child: SingleChildScrollView(
                  child: EmailHistoryWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
