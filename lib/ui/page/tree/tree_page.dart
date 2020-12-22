
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/data/entity/category.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/ui/common/page_wrapper.dart';
import 'package:wanandroid_flutter/ui/common/wrap_layout.dart';
import 'package:wanandroid_flutter/ui/page/tree/tree_detail_tab_page.dart';

class TreePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TreePageState();

}

class _TreePageState extends State<TreePage> {
  RefreshController _refreshController;
  List<Category> categories = [];
  Future category;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadTreeCategory();
  }

  _loadTreeCategory() async {
    category = WanRepository().getTreeCategory();
    CategoryWrapper result = await category;
    categories = result.data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: category,
      builder: (context, snapshot) {
        return PageWrapper(
          refreshController: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: _loadTreeCategory,
          snapshot: snapshot,
          isLoadMore: false,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 20.0, 5.0, 10.0),
                            child: Text(categories[index].name),
                          ),
                          WrapLayout(
                            contents: categories[index].children,
                            onItemClick: (item, position){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) =>
                                    TreeDetailTabPage(category: categories[index],
                                        selectTabIndex: position)));
                            },
                          )
                        ],
                      );
                    },
                  childCount: categories.length
                ),
              )
            ],
          ),
        );
      },
    );
  }

}