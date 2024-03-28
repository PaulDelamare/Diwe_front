import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityWidget extends StatefulWidget {
  final Widget connectedChild; // Widget à afficher lorsque la connexion est établie
  final Widget disconnectedChild; // Widget à afficher lorsque la connexion est perdue

  const ConnectivityWidget({
    Key? key,
    required this.connectedChild,
    required this.disconnectedChild,
  }) : super(key: key);

  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    // Écouter les changements de connectivité
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
        ),
        body: Center(
          child: _connectivityResult != ConnectivityResult.none
              ? widget.connectedChild // Afficher la page connectée
              : widget.disconnectedChild, // Afficher la page déconnectée
        ),
      ),
    );
  }
}
