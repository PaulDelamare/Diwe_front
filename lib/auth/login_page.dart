import 'package:flutter/material.dart';
import '../service/authService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  Future<void> _login() async {
    try {
      await authService.login(_emailController.text, _passwordController.text);
      final String? token = await authService.getToken();
      final dynamic user = await authService.getUser();

      // Si la connexion est réussie, naviguez vers la page des utilisateurs
      Navigator.of(context).pushReplacementNamed('/user');
    } catch (error) {
      String errorMessage = 'Erreur de connexion';

      if (error is ServiceException) {
        List<dynamic> errors = error.responseBody['errors'];
        errorMessage = 'Invalid credentiel';
      }

      print("ErrorMessage: $errorMessage");

      final snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: getScreenHeight(context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF004396),
                Color(0xFF0066CC),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: getScreenHeight(context) * 0.1,
                ),

                Image.asset(
                  'assets/images/diwe_blanc.png',
                  width: 250,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF004396)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                  ),
                  onPressed: () {
                    _login();
                  },
                  child: Text('VALIDER'),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
