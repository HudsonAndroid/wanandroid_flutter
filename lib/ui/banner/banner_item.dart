
import 'package:flutter/material.dart';

class BannerItem{
  String imagePath;
  Widget text;
  String jumpLink;

  BannerItem(this.imagePath, this.text, this.jumpLink);

  factory BannerItem.create(String imagePath, String text, String jumpLink){
    Text textWidget = Text(
      text,
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white, fontSize: 12.0, decoration: TextDecoration.none
      ),
    );
    return BannerItem(imagePath, textWidget, jumpLink);
  }
}