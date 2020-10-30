

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
  bool isLoadMore = false;

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
  }

  _transformBanner(List<WanBanner> banners) {
    bannerList.clear();
    for(var i = 0; i < banners.length; i++){
      bannerList.add(BannerItem.create(banners[i].imagePath, banners[i].title, banners[i].url));
    }
  }

  _loadMore() async {
    if(!hasMore) return ; // no more data, skip
    // curPage已经置换成服务端返回的值，不需要自增，因此直接触发
    setState(() {
      isLoadMore = true;
    });
  }

  _refresh() {
    curPage = 0;
    hasMore = true;
    isLoadMore = false;
    bannerList.clear();
    articleList.clear();
    setState(() {});
  }

  // todo 残留一个问题，在外部嵌套了FutureBuilder之后，SmartRefresher滑动不到最底部，无法显示加载中内容
  @override
  Widget build(BuildContext context) {
    final WanRepository repository = WanRepository();
    // 服务端返回的curPage比实际请求连接的pageNo多1，因此直接使用服务端返回的结果，不自增
    Future<ArticleListWrapper> articles = repository.homePageArticle(curPage);
    Future<List<dynamic>> futureMul;
    if(isLoadMore){
      futureMul = Future.wait([articles]);
    }else{
      Future<List<WanBanner>> banner = repository.banner();
      futureMul = Future.wait([banner, articles]);
    }
    return FutureBuilder(
      future: futureMul,
      // 同时监听两个请求（这里有个问题，就是第二次加载更多实际并没有触发banner加载，但结果中却有banner数据）
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
        if(snapshot.hasData){
          ArticleListWrapper result;
          if(snapshot.data.length == 2){
            _transformBanner(snapshot.data[0]);
            result = snapshot.data[1];
          }else{
            result = snapshot.data[0];
          }
          curPage = result.curPage;
          articleList.addAll(result.datas);
          hasMore = !result.over;
          _refreshController.refreshCompleted(); // 控制下拉， 刷新完成
          if(hasMore){
            _refreshController.loadComplete(); //控制上拉， 还有更多数据，仅通知完成本次加载
          }else{
            _refreshController.loadNoData(); // 没有更多数据，全部加载完成
          }
        }
        return PageWrapper(
            refreshController: _refreshController,
            onRefresh: _refresh,
            onLoading: _loadMore,
            snapshot: snapshot,
            isLoadMore: isLoadMore,
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
      },
    );
  }

}