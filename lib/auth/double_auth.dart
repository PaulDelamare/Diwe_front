import 'dart:async';
import 'package:diwe_front/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:diwe_front/custom/background_bubble_custom.dart';
import 'package:diwe_front/Auth/login_page.dart';

class DoubleAuthPage extends StatefulWidget {
  final String email;

  const DoubleAuthPage({Key? key, required this.email}) : super(key: key);

  @override
  _DoubleAuthPageState createState() => _DoubleAuthPageState();
}

class _DoubleAuthPageState extends State<DoubleAuthPage> {
  final AuthService authService = AuthService();

  final TextEditingController _codeController = TextEditingController();
  bool _isVerifyButtonDisabled = false;
  bool _isResendButtonDisabled = false;
  int _resendCountdownSeconds = 60;


  void _verifyCode() async {
    try {
      await authService.verifycode(context, widget.email, _codeController.text);
      // La navigation est déjà gérée dans verifycode
    } catch (e) {
      // Gérez l'erreur si nécessaire, par exemple, en affichant une SnackBar
      print(e);
    }
  }

  void _resendCode() async {
    print("Resend code");
    try {
      await authService.resend_code(context, widget.email);
      // Code de succès ici, si nécessaire
    } catch (e) {
      // Gérez l'erreur si nécessaire, par exemple, en affichant une SnackBar
      print(e);
    }

    setState(() {
      _isResendButtonDisabled = true;
    });

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_resendCountdownSeconds > 0) {
        setState(() {
          _resendCountdownSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResendButtonDisabled = false;
          _resendCountdownSeconds = 60; // Réinitialiser pour la prochaine fois
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
            icon: Icon(Icons.arrow_back, color: Color(0xff004396)),
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
            // Vos bulles de fond ici

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/diwe_blanc.png', width: 250),
                  SizedBox(height: 20),
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
                    onPressed: _isVerifyButtonDisabled ? null : _verifyCode,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xff004396)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Text('Vérifier le code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isResendButtonDisabled ? null : _resendCode,
                    child: Text('Renvoyer le mail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  if (_isResendButtonDisabled)
                    Text(
                      'Veuillez attendre $_resendCountdownSeconds secondes avant de réessayer.',
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
