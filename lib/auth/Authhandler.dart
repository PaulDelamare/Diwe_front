import 'package:flutter/material.dart';
import '../service/authService.dart';

class AuthHandler extends StatelessWidget {
  // Liste des rôles que vous souhaitez vérifier
  final List<String> roles;
  // Fonction à appeler lorsque l'utilisateur est connecté et a le rôle requis
  final Widget Function(BuildContext) onLoggedIn;
  // Fonction à appeler lorsque l'utilisateur n'est pas connecté ou n'a pas le rôle requis
  final Widget Function(BuildContext) onLoggedOut;

  AuthHandler({
    required this.roles,
    required this.onLoggedIn,
    required this.onLoggedOut,
  });

  @override
  Widget build(BuildContext context) {
    /* Utilisation de FutureBuilder pour gérer de manière asynchrone la vérification des rôles et de la connexion WiFi */
    return FutureBuilder<bool>(
      /* Appel de la méthode hasAnyUserRole de la classe AuthService pour vérifier les rôles */
      future: AuthService().hasAnyUserRole(roles),
      builder: (context, snapshot) {
        /* Vérifier si la vérification des rôles est en cours */
        if (snapshot.connectionState == ConnectionState.waiting) {
          /* Afficher un indicateur de chargement pendant la vérification */
          return CircularProgressIndicator();
        } else {
          /* Si la vérification est terminée, vérifiez la connexion WiFi */
          return FutureBuilder<bool>(
            /* Appel de la méthode isWiFiConnected de la classe AuthService pour vérifier la connexion WiFi */
            future: AuthService().isWiFiConnected(),
            builder: (context, wifiSnapshot) {
              /* Vérifier si la vérification de la connexion WiFi est en cours */
              if (wifiSnapshot.connectionState == ConnectionState.waiting) {
                /* Afficher un indicateur de chargement pendant la vérification */
                return CircularProgressIndicator();
              } else {
                /* Si la vérification est terminée, afficher le widget approprié en fonction du résultat */
                if (snapshot.data == true && wifiSnapshot.data == true) {
                  return onLoggedIn(context);
                } else {
                  // Afficher un AlertDialog si l'utilisateur n'est pas connecté au WiFi
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Veuillez connecter aux réseaux internet'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  return onLoggedOut(context);
                }
              }
            },
          );
        }
      },
    );
  }
}
