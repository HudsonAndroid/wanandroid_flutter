
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final String text;
  final TextStyle style;
  final VoidCallback onPressed;
  final Color bgColor, borderColor;
  final double roundRadius;
  final EdgeInsetsGeometry margin;

  const RoundButton({
    Key key,
    this.width,
    this.height = 50,
    this.child,
    this.text,
    this.style,
    this.onPressed,
    this.bgColor,
    this.roundRadius,
    this.margin,
    this.borderColor
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = bgColor ?? Theme.of(context).primaryColor;
    Color border = borderColor ?? color;
    BorderRadius borderRadius = BorderRadius.circular(roundRadius ?? (height / 2));
    return Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.only(top: 30),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(color: border)
        ),
      ),
      child: Material(
        borderRadius: borderRadius,
        color: color,
        child: InkWell(
          borderRadius: borderRadius, // 里面也要加，不然Ripple效果会是长方形的
          onTap: onPressed,
          child: child ?? Center(
            child: Text(text, style: style ?? TextStyle(color: Colors.white, fontSize: 15),),
          ),
        ),
      ),
    );
  }

}