import 'package:flutter/material.dart';
import '../service/authService.dart';

class AuthHandler extends StatelessWidget {
  final List<String> roles;
  final Widget Function(BuildContext) onLoggedIn;
  final Widget Function(BuildContext) onLoggedOut;

  AuthHandler({
    required this.roles,
    required this.onLoggedIn,
    required this.onLoggedOut,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().hasAnyUserRole(roles),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          // Vérifiez simplement les rôles sans prendre en compte la connexion WiFi
          if (snapshot.data == true) {
            return onLoggedIn(context);
          } else {
            // Affichez le widget onLoggedOut si les rôles ne correspondent pas
            return onLoggedOut(context);
          }
        }
      },
    );
  }
}