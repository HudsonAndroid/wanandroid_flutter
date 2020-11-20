
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/common/common_const_var.dart';
import 'package:wanandroid_flutter/ui/common/page_wrapper.dart';

/// 加载一页数据； 确保返回的结果是列表的一页数据类型
typedef LoadPage = Future<dynamic> Function(int curPage);
/// 页码自增规则
typedef PageNoIncrementStrategy = int Function(int localPageNo, int serverReturnPage);
/// 获取页数据实体中的列表数据
typedef GetPageListEntities = dynamic Function(dynamic pageWrapper);
/// 根据页数据实体判定是否还有更多数据
typedef PageHasMore = bool Function(dynamic pageWrapper);
/// 构建一项的Widget
typedef ItemWidgetHolder = Widget Function(int index, dynamic entity, {OnItemDelete onItemDelete});
typedef OnItemDelete = void Function(int index);
/// 外界控制者尝试同步删除操作，bool返回true表示同步删除成功，否则失败
typedef TryToDelete = Future<bool> Function(int index, dynamic entity);

/// 统一列表页面，支持下拉刷新、上拉加载更多、显示加载情况和重试方案
/// 参数中 [startPage]用于指示列表加载的起始pageNo，因为部分功能
/// 服务端列表起始位置是0，部分起始是1。由于列表获取下来没有配对是否
/// 重复的逻辑，因此需要外界明确指定起始页的下标。（另外，起始页为0的情况下
/// 每次请求默认不会自动增加，因为服务端返回的页码是下一页；起始页为1的情况
/// 下，会自动增加，见[PageNoIncrementStrategy]函数）
/// [loadPage]用于指明列表获取的网络接口
class ListPageWrapper extends StatefulWidget {
  final int startPage;
  final LoadPage loadPage;
  final ItemWidgetHolder itemWidgetHolder;
  final PageNoIncrementStrategy strategy;
  final GetPageListEntities getPageListEntities;
  final PageHasMore pageHasMore;
  final TryToDelete tryToDelete;

  ListPageWrapper({
    Key key,
    this.startPage = 0,
    @required this.loadPage,
    @required this.itemWidgetHolder,
    this.strategy,
    this.getPageListEntities,
    this.pageHasMore,
    this.tryToDelete
  }) : assert(loadPage != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ListPageWrapperState();

}

class _ListPageWrapperState extends State<ListPageWrapper> {
  RefreshController _refreshController;
  List<dynamic> listEntities = []; // page list entities
  int curPage;
  bool hasMore = true;
  bool isLoadMore = false;
  bool isRefresh = false;
  Future loadPage;

  @override
  void initState() {
    curPage = widget.startPage;
    _loadPageData();
    _refreshController = RefreshController();
    super.initState();
  }

  _loadPageData() async {
    if(!hasMore) return ;
    loadPage = widget.loadPage(curPage);
    dynamic result = await loadPage;
    curPage = widget.strategy == null ? (curPage + 1) : widget.strategy(curPage, result.curPage);
    setState(() {
      // curPage = result.curPage;
      listEntities.addAll(widget.getPageListEntities == null ? result.datas : widget.getPageListEntities(result));
      hasMore = widget.pageHasMore == null ? !result.over : widget.pageHasMore(result);
      isLoadMore = curPage != widget.startPage;
    });
    if(hasMore){
      _refreshController.loadComplete(); // 还有更多数据，仅通知完成本次加载
    }else{
      _refreshController.loadNoData(); // 没有更多数据，全部加载完成
    }
    _checkRefreshState();
  }

  _checkRefreshState(){
    if(isRefresh){
      _refreshController.refreshCompleted();
      isRefresh = false;
    }
  }

  _refresh() {
    curPage = widget.startPage;
    hasMore = true;
    isRefresh = true;
    listEntities.clear();
    _loadPageData();
  }

  onItemDelete(int index) async {
    // 删除
    var entity = listEntities[index];
    setState(() {
      listEntities.removeAt(index);
    });
    if(widget.tryToDelete != null){
      bool success = await widget.tryToDelete(index, entity);
      print('是否成功$success');
      if(!success){
        // Outer controller delete failed, we should recover it and notify user.
        setState(() {
          listEntities.insert(index, entity);
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: ConstVar.COMMON_SNACK_BAR_DURATION),
          content: Text("抱歉，删除失败！"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadPage,
      builder: (context, snapshot) {
        return PageWrapper(
          refreshController: _refreshController,
          onRefresh: _refresh,
          onLoading: _loadPageData,
          snapshot: snapshot,
          isLoadMore: isLoadMore,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                // 大小设置成*2-1目的是增加分割线，见
                // https://stackoverflow.com/questions/57752853/separator-divider-in-sliverlist-flutter
                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index){
                      final int itemIndex = index ~/ 2;
                      if(index.isEven){
                        return widget.itemWidgetHolder(itemIndex, listEntities[itemIndex], onItemDelete: onItemDelete);
                      }
                      return Divider(height: 0, color: Colors.grey,);
                    },
                    semanticIndexCallback: (Widget widget, int localIndex){
                      if(localIndex.isEven) {
                        return localIndex ~/ 2;
                      }
                      return null;
                    },
                    childCount: max(0, listEntities.length * 2 - 1)
                ),
              )
            ],
          ),
        );
      },
    );
  }

}