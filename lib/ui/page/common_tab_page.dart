import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/common/common_const_var.dart';
import 'package:wanandroid_flutter/data/entity/category.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
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
    this.initialIndex = 0,
    this.articleStarIndex
  }) : super(key: key);

  final String title;
  final LoadTabCategories loadTabCategories;
  final LoadCategoryArticle loadCategoryArticle;
  final List<Category> inputCategories;
  final int initialIndex;
  final int articleStarIndex;

  @override
  _CommonTabPageState createState() => _CommonTabPageState();
}

class _CommonTabPageState extends State<CommonTabPage> with SingleTickerProviderStateMixin {
  RefreshController _refreshController;
  TabController _tabController;
  List<Category> categories = [];
  Future category;
  bool hasLoadCompleted = false;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadCategory();
  }

  _loadCategory() async {
    try{
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
    }catch(e){
      // 如果中间出现错误，那么说明加载完成了，进一步判定tabController是否是null来决定是否加载失败
      hasLoadCompleted = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_tabController == null) {
      // 如果tabController是空的，不应该只是展示loading，我们需要自行根据情况
      // 判定成功和失败
      if(hasLoadCompleted){
        // 说明失败了
        return Container(
          width: double.infinity,
          color: Theme.of(context).cardColor,
          child: InkWell(
            onTap: _loadCategory,// 重试操作
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.mood_bad),
                Text(S.of(context).tips_error_retry)
              ],
            ),
          ),
        );
      }
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
                  unselectedLabelColor:  Theme.of(context).unselectedWidgetColor,
                  labelColor: Theme.of(context).textSelectionHandleColor,
                  indicatorColor: Theme.of(context).textSelectionHandleColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
              Flexible(
                  flex: 2,
                  child: TabBarView(
                    controller: _tabController,
                    children: List<Widget>.generate(categories.length, (index){
                      return ArticlePage(
                        startPage: widget.articleStarIndex ?? 1,
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
