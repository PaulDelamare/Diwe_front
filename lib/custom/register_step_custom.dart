import 'package:flutter/material.dart';

class RegisterStepCustom extends StatelessWidget {
  final String? stepNumberLeft;
  final String? stepNumberRight;

  const RegisterStepCustom({
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
          _buildCircleIndicator(stepNumberLeft ?? "", true),
          Expanded(
            child: Divider(color: Colors.white, thickness: 2),
          ),
          _buildCircleIndicator(stepNumberRight ?? "", false),
        ],
      ),
    );
  }

  Widget _buildCircleIndicator(String number, bool isLeftPin) {
    double size = number.isNotEmpty ? 40 : 20;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: size,
          height: size,
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
            fontSize: 18
          ),
        ),
      ],
    );
  }
}
