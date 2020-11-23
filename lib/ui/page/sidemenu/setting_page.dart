
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/common/state/theme_manager.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/page/sidemenu/theme/theme_choice_dialog.dart';

class SettingPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {


  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).sideMenuSettings),
      ),
      body: Column(
        children: <Widget>[
          SettingItem(S.of(context).setting_app_theme, ThemeManager.getThemeDesc(context,themeManager.themeMode), () {
            showDialog(context: context, builder: (context) => ThemeChoiceDialog());
          }),
          Divider(height: 0, color: Colors.grey,)
        ],
      ),
    );
  }

}

typedef OnSettingClick = void Function();

class SettingItem extends StatelessWidget {
  final String title;
  final String content;
  final OnSettingClick onSettingClick;

  SettingItem(this.title, this.content, this.onSettingClick);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: <Widget>[
          Text(title),
          Expanded(child: SizedBox(),),
          InkWell(
            onTap: onSettingClick,
            child: Text(content),
          )
        ],
      ),
    );
  }

}