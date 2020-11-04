
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
/// 侧边栏
/// 参考：https://medium.com/@maffan/how-to-create-a-side-menu-in-flutter-a2df7833fdfb
class NavDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(S.of(context).appName, style: TextStyle(color: Colors.white, fontSize: 18),),
            // decoration: BoxDecoration(
            //   image: AssetImage('assets/images/')
            // ),
          ),
          ListTile(// 问答
            leading: Icon(Icons.mouse),
            title: Text(S.of(context).sideMenuAsk),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(// 广场
            leading: Icon(Icons.question_answer),
            title: Text(S.of(context).sideMenuSquare),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(// 设置
            leading: Icon(Icons.settings),
            title: Text(S.of(context).sideMenuSettings),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(S.of(context).action_logout),
            onTap: () => {

            },
          )
        ],
      ),
    );
  }

}