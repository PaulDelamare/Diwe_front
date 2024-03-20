import 'dart:async';
import 'package:flutter/material.dart';
import 'package:diwe_front/custom/background_bubble_custom.dart';
import 'package:diwe_front/Auth/login_page.dart'; // Assurez-vous que ce chemin est correct

class DoubleAuthPage extends StatefulWidget {
  final String email;

  const DoubleAuthPage({Key? key, required this.email}) : super(key: key);

  @override
  _DoubleAuthPageState createState() => _DoubleAuthPageState();
}

class _DoubleAuthPageState extends State<DoubleAuthPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isButtonDisabled = false;
  int _countdownSeconds = 30;

  void _verifyCode() {
    print("Code submitted: ${_codeController.text}");

    setState(() {
      _isButtonDisabled = true;
    });

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isButtonDisabled = false;
          _countdownSeconds = 30; // Réinitialise le timer pour la prochaine utilisation
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),

      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff004396),
              Color(0xff0C8CE9),
            ],
          ),
        ),
        child: Stack(
          children: [
            BackgroundBubble(left: -100, top: -90, color: Color(0x00C7E6).withOpacity(0.3), width: 300, height: 300),
            BackgroundBubble(right: -100, bottom: -90, color: Color(0x00C7E6).withOpacity(0.3), width: 300, height: 300),
            BackgroundBubble(left: 50, top: 600, color: Color(0x00C7E6).withOpacity(0.3), width: 80, height: 80),
            BackgroundBubble(right: 90, top: 100, color: Color(0x00C7E6).withOpacity(0.3), width: 100, height: 100),
            BackgroundBubble(right: -90, top: 300, color: Color(0x00C7E6).withOpacity(0.3), width: 250, height: 250),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/diwe_blanc.png', width: 250),
                  Text(
                    'Double Authentification',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Entrez le code reçu par mail',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Code de vérification',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isButtonDisabled ? null : _verifyCode,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff004396),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Vérifier le code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  SizedBox(height: 20),
                  if (_isButtonDisabled)
                    Text(
                      'Veuillez attendre $_countdownSeconds secondes avant de réessayer.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
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
