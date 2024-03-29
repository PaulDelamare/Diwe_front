import 'package:flutter/material.dart';

class DoctorListingPage extends StatelessWidget {

  DoctorListingPage();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        // Ajoutez ici le code pour gérer la sélection d'un élément
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
