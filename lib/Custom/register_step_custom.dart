import 'package:flutter/material.dart';

class RegisterStepCustom extends StatelessWidget {
  final String? stepNumberLeft;
  final String? stepNumberRight;


  const RegisterStepCustom ({
    Key? key,
     this.stepNumberLeft,
     this.stepNumberRight,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          _buildCircleIndicator(stepNumberLeft!, true),
          Expanded(
            child: Divider(color: Colors.white, thickness: 2),
          ),
          _buildCircleIndicator(stepNumberRight!, false),
        ],
      ),
    );
  }

  Widget _buildCircleIndicator(String number, bool isLeftPin) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          number,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
