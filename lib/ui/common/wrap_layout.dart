
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/ui/common/round_rectangle.dart';

typedef OnItemClick = void Function(dynamic item);

class WrapLayout extends StatelessWidget {
  final List<dynamic> contents;
  final OnItemClick onItemClick;
  final double radius;

  WrapLayout({Key key, this.contents, this.onItemClick, this.radius = 6.0}): super(key: key);

  @override
  Widget build(BuildContext context) {
    var radius = BorderRadius.circular(6.0);
    return Wrap(
      direction: Axis.horizontal,
      children: List<Widget>.generate(contents.length, (index){
        return Container(
          margin: EdgeInsets.all(6.0),
          child: Material(
            borderRadius: radius,
            child: InkWell(
              onTap: (){
                onItemClick(contents[index]);
              },
              child: RoundRectangle(
                padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                text: contents[index].toString(),
                radius: radius,
              ),
            ),
          ),
        );
      }),
    );
  }

}