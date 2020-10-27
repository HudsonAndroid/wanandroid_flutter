
import 'package:flutter/material.dart';

class WechatPage extends StatefulWidget {
    WechatPage({Key key, this.title}) : super(key:key);

    final String title;

    @override
    _WechatPageState createState() => _WechatPageState();

}

class _WechatPageState extends State<WechatPage> {

    @override
    Widget build(BuildContext context) {
        return Text('我是微信公众号也没');
    }
}