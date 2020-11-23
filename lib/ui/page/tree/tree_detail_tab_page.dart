
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/data/entity/category.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';

import '../common_tab_page.dart';

/// 体系tab中的tree页面，点击跳转的结果页面(时一个tab页面)
class TreeDetailTabPage extends StatelessWidget {
  /// 该页面所需的tree分类tab
  final Category category;
  final int selectTabIndex;

  TreeDetailTabPage({
    Key key,
    @required this.category,
    this.selectTabIndex = 0
  }) : assert(category != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: CommonTabPage(
        title: category.name,
        loadCategoryArticle: (int category, int curPage) async {
          return WanRepository().getTreeArticles(category, curPage);
        },
        // not work! 这种直接返回的方式不会触发FutureBuilder的snapshot刷新
        loadTabCategories: () async {
          return category.children;
        },
        inputCategories: category.children,
        initialIndex: this.selectTabIndex,
        articleStarIndex: 0,
      ),
    );
  }

}