import 'package:diwe_front/auth/auth_page.dart';
import 'package:diwe_front/main.dart';
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

  bool _isLoading = false; // Ajout de la variable pour suivre l'état du chargement

  // Définition du widget de chargement
  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Affichage du chargement lorsque le processus de connexion commence
    });

    try {
      // Modification ici: passage de 'context' comme premier argument
      await authService.login(context, _emailController.text, _passwordController.text);
      final String? token = await authService.getToken();
      final dynamic user = await authService.getUser();

      print(" JWT Token : ezaeaze $token");

      // Si la connexion est réussie, naviguez vers la page des utilisateurs
      if (mounted && token != null) {
      }
      else {
        // Gérer le cas où le token est nul après la connexion réussie
        print("Erreur de récupération du token");
        // Afficher une snackbar ou une alerte à l'utilisateur
      }
    } catch (error) {
      print(error);
      String errorMessage = 'Erreur de connexion';

      if (error is ServiceException) {
        List<dynamic> errors = error.responseBody['errors'];
        errorMessage = 'Identifiants invalides';

      }

      print("ErrorMessage: $errorMessage");

      final snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        _isLoading = false; // Masquage du chargement une fois le processus terminé
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading // Affichage du widget de chargement si _isLoading est vrai
          ? _buildLoadingWidget()
          : SingleChildScrollView(
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
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xFF004396)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15)),
                  ),
                  onPressed: () {
                    _login();
                  },
                  child: Text('VALIDER'),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      // Naviguer vers une nouvelle page nommée AuthPage
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Authpage()));
                    },

                    child: Text('Retour en arrière', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
