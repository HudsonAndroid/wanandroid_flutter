import 'package:flutter/material.dart';
/// 由于系统本身存在banner，因此和我们自定义的banner冲突，需要处理冲突
import 'package:wanandroid_flutter/banner/banner.dart' as CustomBanner;
import 'package:wanandroid_flutter/common/WebUtil.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';

import 'banner/banner_item.dart';
import 'data/entity/wan_banner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BannerItem> bannerList = [];

  @override
  void initState() {
    _loadBanners();
    super.initState();
  }

  _loadBanners() async {
    List<WanBanner> banners = await WanRepository().banner();
    List<BannerItem> transforms = [];
    for(var i = 0; i < banners.length; i++){
      transforms.add(BannerItem.create(banners[i].imagePath, banners[i].title, banners[i].url));
    }
    if(!mounted) return ;
    setState(() {
      bannerList = transforms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CustomBanner.Banner(
              bannerList,
                itemClickListener: (index, item){
                  /// 点击跳转
                  jumpWeb(item.jumpLink);
                }
            )
          ],
        ),
      ),
    );
  }
}
