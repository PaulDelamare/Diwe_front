import 'package:flutter/material.dart';
import 'glycemie.dart';
import 'glucide.dart';
import 'correction.dart';
import 'suggestion.dart';
import 'boutons.dart';

class BolusPage extends StatefulWidget {
  const BolusPage({Key? key}) : super(key: key);

  @override
  _BolusPageState createState() => _BolusPageState();
}

class _BolusPageState extends State<BolusPage> {
  String? _selectedUnit = 'mmol/L';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF004396), Color(0xFF0C8CE9)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child:SingleChildScrollView( 
                  child:Column(
                  children: [
                    SizedBox(height: 10),
                    GlycemieCircle(
                      selectedUnit: _selectedUnit,
                      onUnitChanged: (newValue) {
                        setState(() {
                          _selectedUnit = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      'GLYCEMIE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    GlucideBlock(),
                    SizedBox(height: 10),
                    CorrectionBlock(),
                    SizedBox(height: 10),
                    SuggestionBlock(),
                    SizedBox(height: 20),
                    ButtonRow(
                      resetButtonText: 'Réinitialiser',
                      saveButtonText: 'Enregistrer',
                      onResetPressed: () {
                        // Action pour le bouton Réinitialiser
                      },
                      onSavePressed: () {
                        // Action pour le bouton Enregistrer
                      },
                    ),
                ],
                ),
                ) 
              ),
            ],
          )
          
        ),
      ),
    );
  }
}
