
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/ui/drawer/nav_drawer.dart';
import 'package:wanandroid_flutter/ui/page/home_page.dart';
// import 'package:wanandroid_flutter/ui/page/home_page_deprecated.dart';
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
        // SmartRefresher的语言库，该库配置说明见 [RefreshLocalizations] 文件说明
        RefreshLocalizations.delegate
      ],
      // 此处由于我们APP整体配置已经配置了zh和en的语言类型，
      // 因此针对SmartRefresher的不需要重复配置
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
    final List<String> title = [
      S.of(context).homePage,
      S.of(context).wechatPage
    ];
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(title[currentIndex]),
      ),
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
            title: Text(title[0])
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text(title[1])
          )
        ],
      ),
      body: IndexedStack(
        children: <Widget>[
          // HomePageDeprecated(title: S.of(context).homePage),
          HomePage(),
          WechatPage(title: S.of(context).wechatPage,)
        ],
        index: currentIndex,
      ),
    );
  }

}
