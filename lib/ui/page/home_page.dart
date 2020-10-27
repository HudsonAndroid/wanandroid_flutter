import 'dart:math';

import 'package:flutter/material.dart';
/// 由于系统本身存在banner，因此和我们自定义的banner冲突，需要处理冲突
import 'package:wanandroid_flutter/banner/banner.dart' as CustomBanner;
import 'package:wanandroid_flutter/banner/banner_item.dart';
import 'package:wanandroid_flutter/common/WebUtil.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/data/entity/wan_banner.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/ui/article/article.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerItem> bannerList = [];
  List<WanArticle> articleList = [];
  int curPage = -1;
  bool hasMore = false;

  @override
  void initState() {
    _loadBanners();
    _loadArticles();
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

  _loadArticles() async {
    ArticleListWrapper result = await WanRepository().homePageArticle(++curPage);
    setState(() {
      curPage = result.curPage;
      articleList = result.datas;
      hasMore = !result.over;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Container(
        // Slivers实现，见https://medium.com/flutter/slivers-demystified-6ff68ab0296f
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(widget.title),
              floating: true,
              snap: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                    [
                      CustomBanner.Banner(
                          bannerList,
                          itemClickListener: (index, item){
                            /// 点击跳转
                            jumpWeb(item.jumpLink);
                          }
                      ),
                    ]
                )
            ),
            SliverList(
              // 大小设置成*2-1目的是增加分割线，见
              // https://stackoverflow.com/questions/57752853/separator-divider-in-sliverlist-flutter
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index){
                    final int itemIndex = index ~/ 2;
                    if(index.isEven){
                      return Article(articleList[itemIndex]);
                    }
                    return Divider(height: 0, color: Colors.grey,);
                  },
                  semanticIndexCallback: (Widget widget, int localIndex){
                    if(localIndex.isEven) {
                      return localIndex ~/ 2;
                    }
                    return null;
                  },
                  childCount: max(0, articleList.length * 2 - 1)
              ),
            )
          ],
        ),
      ),
    );
  }
}