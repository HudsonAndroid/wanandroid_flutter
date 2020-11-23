
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/ui/article/article.dart';
import 'package:wanandroid_flutter/ui/common/list_page_wrapper.dart';
import 'package:wanandroid_flutter/ui/common/page_wrapper.dart';

typedef LoadArticle = Future<ArticleListWrapper> Function(int curPage);

/// 统一文章列表页面，支持下拉刷新、上拉加载更多、显示加载情况和重试方案
/// 参数中 [startPage]用于指示文章列表加载的起始pageNo，因为部分功能
/// 服务端文章列表起始位置是0，部分起始是1。由于列表获取下来没有配对是否
/// 重复的逻辑，因此需要外界明确指定起始页的下标。（另外，起始页为0的情况下
/// 每次请求默认不会自动增加，因为服务端返回的页码是下一页；起始页为1的情况
/// 下，会自动增加，见_autoIncrementPageNoStrategy()函数）
/// [loadArticle]用于指明文章列表获取的网络接口
class ArticlePage extends StatelessWidget {
  final int startPage;
  final LoadArticle loadArticle;

  ArticlePage({
    Key key,
    this.startPage = 0,
    @required this.loadArticle
  }) : assert(loadArticle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListPageWrapper(
      startPage: startPage,
      loadPage: loadArticle,
      itemWidgetHolder: (index, entity, {OnItemDelete onItemDelete}){
        return Article(entity);
      },
      strategy: (int localPage, int serverPageNo){
        if(startPage == 1){
          return localPage + 1;
        }else{
          return serverPageNo;
        }
      },
    );
  }


  // @override
  // State<StatefulWidget> createState() => _ArticleState();

}

// class _ArticleState extends State<ArticlePage> {
//   RefreshController _refreshController;
//   List<WanArticle> articleList = [];
//   int curPage;
//   bool hasMore = true;
//   bool isLoadMore = false;
//   bool isRefresh = false;
//   Future loadArticle;
//
//   @override
//   void initState() {
//     curPage = widget.startPage;
//     _loadArticles();
//     _refreshController = RefreshController();
//     super.initState();
//   }
//
//   // 部分情况下，服务端返回的curPage比实际请求连接的pageNo多1，因此直接使用服务端返回的结果，不自增
//   // 这与服务端的配置相关
//   _autoIncrementPageNoStrategy(int serverPageNo) {
//     if(widget.startPage == 1){
//       curPage ++;
//     }else{
//       curPage = serverPageNo;
//     }
//   }
//
//   _loadArticles() async {
//     if(!hasMore) return ;
//     loadArticle = widget.loadArticle(curPage);
//     ArticleListWrapper result = await loadArticle;
//     _autoIncrementPageNoStrategy(result.curPage);
//     setState(() {
//       // curPage = result.curPage;
//       articleList.addAll(result.datas);
//       hasMore = !result.over;
//       isLoadMore = curPage != widget.startPage;
//     });
//     if(hasMore){
//       _refreshController.loadComplete(); // 还有更多数据，仅通知完成本次加载
//     }else{
//       _refreshController.loadNoData(); // 没有更多数据，全部加载完成
//     }
//     _checkRefreshState();
//   }
//
//   _checkRefreshState(){
//     if(isRefresh){
//       _refreshController.refreshCompleted();
//       isRefresh = false;
//     }
//   }
//
//   _refresh() {
//     curPage = widget.startPage;
//     hasMore = true;
//     isRefresh = true;
//     articleList.clear();
//     _loadArticles();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: loadArticle,
//       builder: (context, snapshot) {
//         return PageWrapper(
//           refreshController: _refreshController,
//           onRefresh: _refresh,
//           onLoading: _loadArticles,
//           snapshot: snapshot,
//           isLoadMore: isLoadMore,
//           child: CustomScrollView(
//             slivers: <Widget>[
//               SliverList(
//                 // 大小设置成*2-1目的是增加分割线，见
//                 // https://stackoverflow.com/questions/57752853/separator-divider-in-sliverlist-flutter
//                 delegate: SliverChildBuilderDelegate(
//                         (BuildContext context, int index){
//                       final int itemIndex = index ~/ 2;
//                       if(index.isEven){
//                         return Article(articleList[itemIndex]);
//                       }
//                       return Divider(height: 0, color: Colors.grey,);
//                     },
//                     semanticIndexCallback: (Widget widget, int localIndex){
//                       if(localIndex.isEven) {
//                         return localIndex ~/ 2;
//                       }
//                       return null;
//                     },
//                     childCount: max(0, articleList.length * 2 - 1)
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
//
// }