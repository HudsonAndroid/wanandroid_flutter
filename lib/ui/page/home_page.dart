

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/common/WebUtil.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/data/entity/wan_banner.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/ui/article/article.dart';
import 'package:wanandroid_flutter/ui/banner/banner_item.dart';
import 'package:wanandroid_flutter/ui/common/page_wrapper.dart';
/// 由于系统本身存在banner，因此和我们自定义的banner冲突，需要处理冲突
import 'package:wanandroid_flutter/ui/banner/banner.dart' as CustomBanner;

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{
  RefreshController _refreshController;
  List<BannerItem> bannerList = [];
  List<WanArticle> articleList = [];
  int curPage = 0;
  bool hasMore = true;

  @override
  void initState() {
    _loadBanners();
    _loadArticles();
    _refreshController = RefreshController();
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
    if(hasMore){
      _refreshController.loadComplete(); // 还有更多数据，仅通知完成本次加载
    }else{
      _refreshController.loadNoData(); // 没有更多数据，全部加载完成
    }
  }

  _refresh() {
    curPage = 0;
    hasMore = true;
    bannerList.clear();
    articleList.clear();
    _loadBanners();
    _loadArticles();
    _refreshController.refreshCompleted(); // 刷新完成
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      refreshController: _refreshController,
      onRefresh: _refresh,
      onLoading: _loadArticles,
      child: CustomScrollView(
        slivers: <Widget>[
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
      )
    );
  }

}