import 'package:diwe_front/auth/auth_page.dart';
import 'package:diwe_front/service/authService.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _oldEmailController = TextEditingController();
  TextEditingController _newEmailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // Libérer les ressources des contrôleurs
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }
  Future<void> _updatePassword(String oldPassword, String newPassword) async {
    setState(() {
      _isLoading = true; // Afficher le chargement lors de la mise à jour du mot de passe
    });

    try {
      final AuthService authService = AuthService();

      // Appeler la fonction d'API pour mettre à jour le mot de passe
      await authService.updatePassword(oldPassword, newPassword);

      // Réinitialiser les champs après enregistrement
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Mot de passe mis à jour avec succès.'),
        backgroundColor: Colors.green,
      ));
    } catch (error) {
      String errorMessage = 'Erreur lors de la mise à jour du mot de passe';

      if (error is ServiceException) {
        // Récupérer le message d'erreur spécifique de la liste d'erreurs
        List<dynamic> errors = error.responseBody['errors'];
        if (errors.isNotEmpty) {
          errorMessage = errors.first['msg'];
        }
      }

      // Afficher un message d'erreur avec le détail de l'erreur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
    } finally {
      // Masquer le chargement après l'opération
      setState(() {
        _isLoading = false;
      });
    }
  }


  bool isEmailValid(String email) {
    // Utilisez une expression régulière pour valider l'adresse email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }


  Future<void> _updateEmail(String oldEmail, String newEmail, String password) async {
    setState(() {
      _isLoading = true; // Afficher le chargement lors de la mise à jour de l'e-mail
    });

    try {
      final AuthService authService = AuthService();

      // Appeler la fonction d'API pour mettre à jour l'e-mail
      await authService.updateEmail(oldEmail, newEmail, password);

      // Réinitialiser les champs après enregistrement
      _oldEmailController.clear();
      _newEmailController.clear();
      _oldPasswordController.clear();

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('E-mail mis à jour avec succès. Veuillez vérifier votre nouvelle adresse e-mail pour confirmer le changement.'),
        backgroundColor: Colors.green,
      ));
    } catch (error) {
      String errorMessage = 'Erreur lors de la mise à jour de l\'e-mail';

      if (error is ServiceException) {
        // Récupérer le message d'erreur de la réponse de l'API
        errorMessage = error.responseBody['error'];
      }

      // Afficher un message d'erreur avec le détail de l'erreur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
    } finally {
      // Masquer le chargement après l'opération
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
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
              ),
            ),
            Positioned(
              top: 75,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
            Positioned(
              top: 75,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Déconnexion'),
                        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Fermer la modal
                            },
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Appeler la méthode de déconnexion
                              await AuthService().logout(context);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => Authpage()),
                              );
                            },
                            child: Text('Déconnexion'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),


            ),
            Positioned(
              top: 150,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Réinitialisation de mot de passe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: true,
                    // Définit le texte comme masqué (mot de passe)
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Ancien mot de passe',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    // Définit le texte comme masqué (mot de passe)
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Nouveau mot de passe',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    // Définit le texte comme masqué (mot de passe)
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Confirmez le nouveau mot de passe',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null // Empêcher le clic si le chargement est en cours
                        : () {
                      // Récupérer les valeurs des champs
                      String oldPassword = _oldPasswordController.text;
                      String newPassword = _newPasswordController.text;
                      String confirmPassword = _confirmPasswordController.text;

                      // Appeler la fonction pour mettre à jour le mot de passe
                      _updatePassword(oldPassword, newPassword);
                    },
                    child: _isLoading
                        ? CircularProgressIndicator() // Afficher un indicateur de chargement s'il est en cours
                        : Text('Enregistrer'),
                  ),
                  Text(
                    'Réinitialisation d\'adresse email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _oldEmailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Ancienne adresse email',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _newEmailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Nouvelle adresse email',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Mot de passe',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      String oldEmail = _oldEmailController.text;
                      String newEmail = _newEmailController.text;
                      String password = _oldPasswordController.text;

                      // Vérifier si les champs ne sont pas vides
                      if (oldEmail.isEmpty || newEmail.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Veuillez remplir tous les champs.'),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                      // Vérifier si la nouvelle adresse email est valide
                      if (!isEmailValid(newEmail)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Veuillez entrer une adresse email valide.'),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                      // Appeler la fonction pour mettre à jour l'email
                      _updateEmail(oldEmail, newEmail, password);
                    },
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Enregistrer'),
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
