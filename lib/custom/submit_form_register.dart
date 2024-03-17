import 'package:flutter/material.dart';

class SubmitForm extends StatelessWidget{
  final String buttonText;
  final int backgroundColor;
  final VoidCallback onPressed;

  const SubmitForm({
    Key? key,
      required this.backgroundColor,
      required this.buttonText,
      required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(16),
        child: (
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF004396)
              ),
              onPressed: onPressed,
              child: Text(buttonText, style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
          )
        )
    );
  }
}