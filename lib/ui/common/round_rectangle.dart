
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 构建圆角矩形（边线）的Widget
class RoundRectangle extends StatelessWidget{
  final BorderRadius radius;
  final Color borderColor;
  final Color textColor;
  final String text;
  final EdgeInsetsGeometry margin, padding;

  RoundRectangle({
    this.radius,
    this.borderColor = Colors.deepOrange,
    @required this.text,
    this.textColor = Colors.black,
    this.margin,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    var roundPadding = padding == null ? EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0) : padding;
    return Container(
      margin: margin,
      padding: roundPadding,
      // alignment: Alignment.center,
      child: Text(text, style: TextStyle(color: textColor, fontSize: 12.0),),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: radius == null ? BorderRadius.circular(6.0) : radius,
          side: BorderSide(color: borderColor)
        ),
      )
    );
  }

}