import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/common/common_util.dart';
import 'package:wanandroid_flutter/data/entity/navigation_item.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/ui/common/page_wrapper.dart';
import 'package:wanandroid_flutter/ui/common/wrap_layout.dart';

class NavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  RefreshController _refreshController;
  List<NavigationItem> navigationList = [];
  Future navigation;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadNavigationList();
  }

  _loadNavigationList() async {
    navigation = WanRepository().getNavigationList();
    NavigationWrapper result = await navigation;
    navigationList = result.data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: navigation,
      builder: (context, snapshot) {
        return PageWrapper(
          refreshController: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: _loadNavigationList,
          snapshot: snapshot,
          isLoadMore: false,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 20.0, 5.0, 10.0),
                        child: Text(navigationList[index].name),
                      ),
                      WrapLayout(
                        contents: navigationList[index].articles,
                        onItemClick: (item, position) {
                          jumpWeb(item.link);
                        },
                      )
                    ],
                  );
                }, childCount: navigationList.length),
              )
            ],
          ),
        );
      },
    );
  }
}
