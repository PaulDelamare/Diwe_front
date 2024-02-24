import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DI WE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage(); // Créez le storage

  Future<void> _login() async {
    final String apiUrl = 'http://10.0.2.2:3000/api/auth/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Connexion réussie, traiter la réponse ici si nécessaire
      print('Connexion réussie');

      // Récupérer le jeton à partir de la réponse JSON
      final token = jsonDecode(response.body)['access_token'];
      // Extraire les données de l'utilisateur
      final user = jsonDecode(response.body)['user'];

      final firstname = user['firstname'];
      final lastname = user['lastname'];
      final email = user['email'];
      final role = user['role'];
      final phone = user['phone'];      

      // Stocker le jeton de manière sécurisée
      await storage.write(key: 'jwt', value: token);

// Imprimer la valeur du jeton
      print(token);
      print(user);

    } else {
      // Connexion échouée, afficher un message d'erreur
      print('Erreur de connexion: ${response.statusCode}');
      print('Corps de la réponse: ${response.body}');
    }
  }



  Widget build(BuildContext context) {
    // Obtenez la hauteur totale de l'écran
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF004396), // Couleur de début
                Color(0xFF0066CC), // Couleur de fin, ajustez selon le dégradé désiré
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.1), // Espace dynamique en fonction de la taille de l'écran
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
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF004396),
                    onPrimary: Colors.white, // Couleur du texte du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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