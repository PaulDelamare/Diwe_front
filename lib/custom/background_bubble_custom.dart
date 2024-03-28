import 'package:flutter/material.dart';

class BackgroundBubble extends StatelessWidget{
  final double ?top;
  final double ?right;
  final double ?bottom;
  final double ?left;
  final Color color;
  final double width;
  final double height;

  const BackgroundBubble({
    Key? key,
      this.top,
      this.right,
      this.bottom,
      this.left,
      required this.color,
      required this.width,
      required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

}

