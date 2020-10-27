
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wanandroid_flutter/ui/page/home_page.dart';
import 'package:wanandroid_flutter/ui/page/wechat_page.dart';
import 'generated/l10n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 下面两个是用于国际化，见https://plugins.jetbrains.com/plugin/13666-flutter-intl
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageContainer(),
    );
  }
}

class PageContainer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _PageContainerState();

}

class _PageContainerState extends State<PageContainer> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 底部切换栏
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        items: [
          // 配置图标
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(S.of(context).homePage)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text(S.of(context).wechatPage)
          )
        ],
      ),
      body: IndexedStack(
        children: <Widget>[
          HomePage(title: S.of(context).homePage),
          WechatPage(title: S.of(context).wechatPage,)
        ],
        index: currentIndex,
      ),
    );
  }

}
