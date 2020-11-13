
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid_flutter/common/state/account_provider.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/ui/drawer/nav_drawer.dart';
import 'package:wanandroid_flutter/ui/page/common_tab_page.dart';
import 'package:wanandroid_flutter/ui/page/home_page.dart';
import 'package:wanandroid_flutter/ui/page/tree_tab_page.dart';
// import 'package:wanandroid_flutter/ui/page/home_page_deprecated.dart';
import 'generated/l10n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider放在MaterialApp将使得整个APP中都可以引用Provider
    // 相关参考 https://stackoverflow.com/questions/57245186/flutter-problem-with-finding-provider-context
    return ChangeNotifierProvider<AccountProvider>(
      create: (_) => AccountProvider(),
      child: MaterialApp(
        // 下面两个是用于国际化，见https://plugins.jetbrains.com/plugin/13666-flutter-intl
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // SmartRefresher的语言库，该库配置说明见 [RefreshLocalizations] 文件说明
          RefreshLocalizations.delegate
        ],
        // 此处由于我们APP整体配置已经配置了zh和en的语言类型，
        // 因此针对SmartRefresher的不需要重复配置
        supportedLocales: S.delegate.supportedLocales,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PageContainer(),
      ),
    );
  }
}

class PageContainer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _PageContainerState();

}

class _PageContainerState extends State<PageContainer> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> title = [
      S.of(context).homePage,
      S.of(context).wechatPage,
      S.of(context).projectPage,
      S.of(context).treePage
    ];
    final WanRepository repository = WanRepository();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(title[currentIndex]),
      ),
      // 底部切换栏
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        // 超过3个时会出问题，见https://stackoverflow.com/questions/52199196/flutter-bottomnavigationbar-not-working-with-more-than-three-items
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: [
          // 配置图标
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(title[0])
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text(title[1])
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            title: Text(title[2])
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text(title[3])
          )
        ],
      ),
      body: IndexedStack(
        children: <Widget>[
          // HomePageDeprecated(title: S.of(context).homePage),
          HomePage(),
          // 微信公众号文章
          CommonTabPage(
            title: S.of(context).wechatPage,
            loadTabCategories: repository.getWxCategory,
            loadCategoryArticle: (int categoryId, int pageNo){
              return repository.getWxArticles(categoryId, pageNo);
            },
          ),
          CommonTabPage(
            title: S.of(context).projectPage,
            loadTabCategories: repository.getProjectCategory,
            loadCategoryArticle: (int categoryId, int pageNo){
              return repository.getProjectArticles(categoryId, pageNo);
            },
          ),
          TreeTabPage(),
        ],
        index: currentIndex,
      ),
    );
  }

}
