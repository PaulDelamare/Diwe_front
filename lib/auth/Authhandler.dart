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
    /* Utilisation de FutureBuilder pour gérer de manière asynchrone la vérification des rôles */
    return FutureBuilder<bool>(
      /* Appel de la méthode hasAnyUserRole de la classe AuthService pour vérifier les rôles */
      future: AuthService().hasAnyUserRole(roles),
      builder: (context, snapshot) {
        /* Vérifier si la vérification des rôles est en cours */
        if (snapshot.connectionState == ConnectionState.waiting) {
          /* Afficher un indicateur de chargement pendant la vérification */
          return CircularProgressIndicator();
        } else {
          /* Si la vérification est terminée, afficher le widget approprié en fonction du résultat */
          return snapshot.data == true ? onLoggedIn(context) : onLoggedOut(context);
        }
      },
    );
  }
}
