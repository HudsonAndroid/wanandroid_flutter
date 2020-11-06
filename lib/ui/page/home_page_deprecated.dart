import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
/// 由于系统本身存在banner，因此和我们自定义的banner冲突，需要处理冲突
import 'package:wanandroid_flutter/ui/banner/banner.dart' as CustomBanner;
import 'package:wanandroid_flutter/ui/banner/banner_item.dart';
import 'package:wanandroid_flutter/common/common_util.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/data/entity/wan_banner.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/ui/article/article.dart';
import 'package:wanandroid_flutter/ui/drawer/nav_drawer.dart';

/// 最原始的方式，通过检测是否滑动到底部来决定是否刷新，已弃用，改为使用SmartRefresher方式
/// 首页
@Deprecated('Use [HomePage] instead.')
class HomePageDeprecated extends StatefulWidget {
  HomePageDeprecated({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageDeprecatedState createState() => _HomePageDeprecatedState();
}

class _HomePageDeprecatedState extends State<HomePageDeprecated> {
  ScrollController _controller;
  List<BannerItem> bannerList = [];
  List<WanArticle> articleList = [];
  int curPage = 0;
  bool hasMore = true;

  _scrollListener(){
    if(_controller.offset >= _controller.position.maxScrollExtent &&
      !_controller.position.outOfRange){// 到达底部
      _loadArticles();// 自动加载更多
    }
  }

  @override
  void initState() {
    _loadBanners();
    _loadArticles();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
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
    if(!hasMore) return ;
    // 服务端返回的curPage比实际请求连接的pageNo多1，因此直接使用服务端返回的结果，不自增
    ArticleListWrapper result = await WanRepository().homePageArticle(curPage);
    setState(() {
      curPage = result.curPage;
      articleList.addAll(result.datas);
      hasMore = !result.over;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      body: Container(
        // Slivers实现，见https://medium.com/flutter/slivers-demystified-6ff68ab0296f
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverAppBar(
              title: Text(widget.title),
              floating: true,
              snap: true,
            ),
            // Banner布局
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
            // 文章列表布局
            SliverList(
              // 大小设置成*2-1目的是增加分割线，见
              // https://stackoverflow.com/questions/57752853/separator-divider-in-sliverlist-flutter

              // 后续增加1，以在尾部增加一个加载更多和数据提示
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index){
                    final int itemIndex = index ~/ 2;
                    // 最尾部展示一个加载更多
                    if(index == articleList.length * 2 - 1){
                      return Container(
                        child: FlatButton(
                          child: Text(hasMore ? S.of(context).loadMore : S.of(context).noMoreData,
                            style: TextStyle(color: Colors.grey),),
                          onPressed: (){
                            _loadArticles();
                          },
                        ),
                      );
                    }
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
                  childCount: max(0, articleList.length * 2 /*- 1*/)
              ),
            )
          ],
        ),
      ),
    );
  }
}