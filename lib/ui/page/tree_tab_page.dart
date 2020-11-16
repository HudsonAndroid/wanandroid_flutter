
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/common_const_var.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/page/tree/navigation_page.dart';
import 'package:wanandroid_flutter/ui/page/tree/tree_page.dart';

class TreeTabPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _TreeTabPageState();
}

class _TreeTabPageState extends State<TreeTabPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: ConstVar.COMMON_TAB_BAR_HEIGHT,
          child: TabBar(
            isScrollable: false,
            tabs: <Widget>[
              Tab(text: S.of(context).tree_sub_tree,),
              Tab(text: S.of(context).tree_sub_navi,)
            ],
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
              children: <Widget>[
                TreePage(),
                NavigationPage()
              ],
            )
        )
      ],
    );
  }
  
}