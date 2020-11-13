import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/data/entity/category.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/ui/common/page_wrapper.dart';
import 'package:wanandroid_flutter/ui/page/article_page.dart';

typedef LoadTabCategories = Future<CategoryWrapper> Function();
typedef LoadCategoryArticle = Future<ArticleListWrapper> Function(int category, int curPage);

/// 微信公众号页面。 内部包含了一个整体的TabView和子页面
class CommonTabPage extends StatefulWidget {
  CommonTabPage({
    Key key,
    this.title,
    this.loadTabCategories,
    this.loadCategoryArticle
  }) : super(key: key);

  final String title;
  final LoadTabCategories loadTabCategories;
  final LoadCategoryArticle loadCategoryArticle;

  @override
  _CommonTabPageState createState() => _CommonTabPageState();
}

class _CommonTabPageState extends State<CommonTabPage> with SingleTickerProviderStateMixin {
  RefreshController _refreshController;
  TabController _tabController;
  List<Category> categories = [];
  Future category;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadWxCategory();
  }

  _loadWxCategory() async {
    category = widget.loadTabCategories();
    CategoryWrapper result = await category;
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
      future: category,
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
                          return widget.loadCategoryArticle(categories[index].id, curPage);
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
