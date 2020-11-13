import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/data/entity/category.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/ui/common/page_wrapper.dart';
import 'package:wanandroid_flutter/ui/page/article_page.dart';

/// 微信公众号页面。 内部包含了一个整体的TabView和子页面
class WechatPage extends StatefulWidget {
  WechatPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WechatPageState createState() => _WechatPageState();
}

class _WechatPageState extends State<WechatPage> with SingleTickerProviderStateMixin {
  RefreshController _refreshController;
  TabController _tabController;
  List<Category> categories = [];
  Future wxCategory;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadWxCategory();
  }

  _loadWxCategory() async {
      wxCategory = WanRepository().getWxCategory();
      CategoryWrapper result = await wxCategory;
      categories = result.data;
      _tabController = TabController(vsync: this, length: categories.length);
  }

  @override
  Widget build(BuildContext context) {
    if(_tabController == null) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }
    return FutureBuilder(
        future: wxCategory,
        builder: (context, snapshot) {
            return PageWrapper(
                refreshController: _refreshController,
                enablePullDown: false,
                enablePullUp: false,
                snapshot: snapshot,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 60,
                      child: TabBar(
                        isScrollable: true,
                        tabs: List<Widget>.generate(categories.length, (index){
                          return Tab(text: categories[index].name,);
                        }),
                        controller: _tabController,
                        unselectedLabelColor:  Colors.black,
                        labelColor: Theme.of(context).primaryColor,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: TabBarView(
                        controller: _tabController,
                        children: List<Widget>.generate(categories.length, (index){
                          return ArticlePage(
                            startPage: 1,
                            loadArticle: (int curPage) {
                              return WanRepository().getWxArticles(categories[index].id, curPage);
                            },
                          );
                        }),
                      )
                    )
                  ],
                ),
            );
        },
    );
  }
}
