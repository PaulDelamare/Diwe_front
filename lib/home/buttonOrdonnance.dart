import 'dart:async';
import 'dart:io';
import 'package:diwe_front/service/pdfService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadOrdonnancePage extends StatefulWidget {
  @override
  _DownloadOrdonnancePageState createState() => _DownloadOrdonnancePageState();
}

class _DownloadOrdonnancePageState extends State<DownloadOrdonnancePage> {

  Future<void> _downloadPDF() async{
    try{
      await PdfService.downloadOrdonnance(context);
    }catch(e){
      print('Erreur lors du telechargement');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _downloadPDF,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: Color(0xFF004396),
                  size: 30,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Text(
                    'Télécharger Mon Ordonnance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
