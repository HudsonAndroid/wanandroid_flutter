import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/common/common_const_var.dart';
import 'package:wanandroid_flutter/data/entity/category.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/ui/common/page_wrapper.dart';
import 'package:wanandroid_flutter/ui/page/article_page.dart';

typedef LoadTabCategories = Future<List<Category>> Function();
typedef LoadCategoryArticle = Future<ArticleListWrapper> Function(int category, int curPage);

/// 微信公众号页面。 内部包含了一个整体的TabView和子页面
/// 由于外界可能直接传递现有的分类数据过来，而如果async的方法
/// 直接返回数据的话，并不会触发FutureBuilder的刷新，因此
/// 增加一个数据字段[inputCategories]以接受外界直接的传递
class CommonTabPage extends StatefulWidget {
  CommonTabPage({
    Key key,
    this.title,
    this.loadTabCategories,
    this.loadCategoryArticle,
    this.inputCategories,
    this.initialIndex = 0
  }) : super(key: key);

  final String title;
  final LoadTabCategories loadTabCategories;
  final LoadCategoryArticle loadCategoryArticle;
  final List<Category> inputCategories;
  final int initialIndex;

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
    _loadCategory();
  }

  _loadCategory() async {
    if(widget.inputCategories != null){
      categories = widget.inputCategories;
    }else{
      category = widget.loadTabCategories();
      categories = await category;
    }
    _tabController = TabController(
        initialIndex: widget.initialIndex,
        vsync: this,
        length: categories.length);
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
                height: ConstVar.COMMON_TAB_BAR_HEIGHT,
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
