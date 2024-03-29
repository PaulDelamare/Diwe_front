import 'package:diwe_front/home/contactCard.dart';
import 'package:flutter/material.dart';

class ContactMail extends StatefulWidget {
  @override
  _ContactMailState createState() => _ContactMailState();
}

class _ContactMailState extends State<ContactMail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contactez-nous'),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  "Contactez-nous",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                ContactFormWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
