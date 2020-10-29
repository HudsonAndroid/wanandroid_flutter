
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/ui/page/home_page.dart';

/// 页面统一抽象页
/// [refreshController] 是用于控制刷新的控制器，虽然名字如此，但也控制着底部加载更多。
/// 在外界触发了[onRefresh]完成后，需要调用 refreshCompleted()方法以关闭刷新指示器的
/// 显示；在外界触发了[onLoading]完成后，需要根据情况调用 loadComplete()或者loadNoData()
/// 具体示例见 [HomePage]页面逻辑。
class PageWrapper extends StatefulWidget {
  final RefreshController refreshController;
  final VoidCallback onRefresh;
  final VoidCallback onLoading;
  final Widget child;

  PageWrapper({
    Key key,
    @required this.refreshController,
    this.onRefresh,
    this.onLoading,
    this.child
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageWrapperState();

}

class _PageWrapperState extends State<PageWrapper> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 加载管理小部件，具体见外部介绍
          SmartRefresher(
            controller: widget.refreshController,
            onRefresh: widget.onRefresh,
            onLoading: widget.onLoading,
            child: widget.child,
            enablePullUp: true, // 允许上拉刷新
          )
        ],
      ),
    );
  }

}