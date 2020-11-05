
import 'package:flutter/material.dart';

/// 自动解析富文本的封装Widget.
/// 不支持针对不同Span触发不同点击的能力，仅支持一个点击
class SpanText extends StatelessWidget {
  final String total;
  final String span;
  final VoidCallback onTap;
  final TextStyle normal;
  final TextStyle focus;
  final EdgeInsetsGeometry margin;

  SpanText({
    Key key,
    @required this.total,
    @required this.span,
    this.onTap,
    this.normal,
    this.focus,
    this.margin
  }):assert(total != null && span != null),
      assert(total.indexOf(span) != -1),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      // 外面嵌套一层InkWell，以便可以触发onTap
      // 见https://stackoverflow.com/questions/44317188/flutter-ontap-method-for-containers
      child: InkWell(
        onTap: onTap,
        child: RichText(
          text: TextSpan(children: decodeStr(context)),
        ),
      )
    );
  }

  List<TextSpan> decodeStr(BuildContext context) {
    List<TextSpan> spans = [];
    int decodeIndex = 0;
    int matchIndex;
    var normalStyle = normal ?? TextStyle(fontSize: 14, color: Colors.grey);
    var focusStyle = focus ?? TextStyle(fontSize: 14, color: Theme.of(context).primaryColor);
    TextSpan item;
    while(decodeIndex < total.length){
      matchIndex = total.indexOf(span);
      if(matchIndex == -1){
        // there is no any more for target span, so end loop
        break;
      }
      item = TextSpan(
          text: total.substring(decodeIndex, matchIndex),
          style: normalStyle
      );
      spans.add(item);
      decodeIndex = matchIndex + span.length; // update decode start index
      item = TextSpan(
        text: total.substring(matchIndex, decodeIndex),
        style: focusStyle
      );
      spans.add(item);
    }
    // 最后还需要把尾部的文本添加上
    item = TextSpan(
        text: total.substring(decodeIndex),
        style: normalStyle
    );
    spans.add(item);
    return spans;
  }

}