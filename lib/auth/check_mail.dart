import 'dart:async';
import 'package:diwe_front/Auth/login_page.dart';
import 'package:diwe_front/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:diwe_front/custom/background_bubble_custom.dart';

class CheckMailPage extends StatefulWidget {
  final String email;

  const CheckMailPage({Key? key, required this.email}) : super(key: key);

  @override
  _CheckMailPageState createState() => _CheckMailPageState();
}
class _CheckMailPageState extends State<CheckMailPage> {
  final AuthService authService = AuthService();
  bool _isButtonDisabled = false;
  int _countdownSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Ne pas appeler _verifyAccount ici pour éviter l'envoi automatique de l'email de confirmation
  }

  void _verifyAccount() async {
    try {
      await authService.active_code(context, widget.email);
      // La navigation est déjà gérée dans active_code
    } catch (e) {
      // Gérez l'erreur si nécessaire, par exemple, en affichant une SnackBar
      print(e);
    }
  }

  void _sendMailAgain() {
    if (_isButtonDisabled) return;

    setState(() {
      _isButtonDisabled = true;
      _countdownSeconds = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() => _countdownSeconds--);
      } else {
        setState(() => _isButtonDisabled = false);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundBubble(
            right: 250,
            bottom: -120,
            color: Color(0xFFFFAB91).withOpacity(0.9),
            width: 300,
            height: 300,
          ),
          BackgroundBubble(
            right: 130,
            bottom: 130,
            color: Color(0xFFFFAB91).withOpacity(0.9),
            width: 80,
            height: 80,
          ),
          BackgroundBubble(
            right: -100,
            top: -80,
            color: Color(0xFFFFAB91).withOpacity(0.9),
            width: 300,
            height: 300,
          ),
          BackgroundBubble(
            left: 100,
            top: 40,
            color: Color(0xFFFFAB91).withOpacity(0.9),
            width: 80,
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/diwe_logo.png', width: 250),
                      SizedBox(height: 100),
                      Text(
                        widget.email,
                        style: TextStyle(
                          color: Color(0xff004396),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Un email de confirmation vous a été envoyé, veuillez le confirmer pour accéder à votre compte.',
                        style: TextStyle(
                          color: Color(0xff004396),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isButtonDisabled ? null : _verifyAccount,
                        child: Text(
                          'Renvoyer le mail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(),
                      ),

                      if (_isButtonDisabled)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Vous pouvez renvoyer le mail dans $_countdownSeconds secondes',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _navigateToLogin,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 1),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xff004396),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff004396),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
