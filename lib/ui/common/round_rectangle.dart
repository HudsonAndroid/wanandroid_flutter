
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 构建圆角矩形（边线）的Widget
class RoundRectangle extends StatelessWidget{
  final double radius;
  final Color color;
  final String text;

  RoundRectangle({this.radius, this.color, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(6.0, 2.0, 3.0, 2.0),
      padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(color: color, fontSize: 12.0),),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: color)
        ),
      )
    );
  }

}