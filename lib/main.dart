
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/ui/page/home_page.dart';
import 'package:wanandroid_flutter/ui/page/wechat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            title: Text('首页')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text('微信公众号')
          )
        ],
      ),
      body: IndexedStack(
        children: <Widget>[
          HomePage(title: '首页'),
          WechatPage(title: '微信公众号',)
        ],
        index: currentIndex,
      ),
    );
  }

}
