import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/common/common_const_var.dart';
import 'package:wanandroid_flutter/common/common_util.dart';
import 'package:wanandroid_flutter/common/state/account_provider.dart';
import 'package:wanandroid_flutter/data/entity/base_result.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/page/login_page.dart';
import 'package:wanandroid_flutter/ui/page/sidemenu/article_page_with_toolbar.dart';
import 'package:wanandroid_flutter/ui/page/sidemenu/setting_page.dart';

/// 侧边栏
/// 参考：https://medium.com/@maffan/how-to-create-a-side-menu-in-flutter-a2df7833fdfb
class NavDrawer extends StatelessWidget {

  _logout(BuildContext context, AccountProvider accountModel) async {
    BaseResult result = await WanRepository().logout();
    if (result.isSuccess()) {
      accountModel.changeCurrentUser(null);
      Navigator.of(context).pop();
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: const Duration(
            milliseconds: ConstVar.COMMON_SNACK_BAR_DURATION),
        content: Text(S
            .of(context)
            .tips_logout_failed),
      ));
    }
  }

  /// 登录状态下会显示，非登录状态下不会显示（不做成StatefulWidget原因是会pop出去，下次进入是重新push）
  Widget _getLogoutMenu(BuildContext context, AccountProvider accountModel) {
    if (accountModel.isLogin()) {
      return ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text(S
            .of(context)
            .action_logout),
        onTap: () {
          _logout(context, accountModel);
        },
      );
    } else {
      return Container();
    }
  }

  Widget _getLoginMenu(BuildContext context, AccountProvider accountModel) {
    if (!accountModel.isLogin()) {
      return ListTile(
        leading: Icon(Icons.person),
        title: Text(S
            .of(context)
            .action_login),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
      );
    } else {
      return Container();
    }
  }

  Widget _getDrawerHeader(BuildContext context, AccountProvider accountModel) {
    var boldTitleStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);
    if (accountModel.isLogin()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 36.0,
            backgroundImage: AssetImage(
                assetsImg('icon_default_user', fileType: 'jpg')),
          ),
          SizedBox(width: 20,),
          Text(accountModel.userInfo.username, style: boldTitleStyle,),
        ],
      );
    } else {
      return Center(
        child: Text(S
            .of(context)
            .appName, style: boldTitleStyle, ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AccountProvider accountModel = Provider.of<AccountProvider>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor
            ),
            child: _getDrawerHeader(context, accountModel),
            // decoration: BoxDecoration(
            //   image: AssetImage('assets/images/')
            // ),
          ),
          _getLoginMenu(context, accountModel),
          ListTile( // 问答
            leading: Icon(Icons.mouse),
            title: Text(S
                .of(context)
                .sideMenuAsk),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ArticlePageWithToolbar(
                loadArticle: (int pageNo){
                  return WanRepository().getAskArticle(pageNo);
                },
                title: S.of(context).menu_ask,
              )));
            },
          ),
          ListTile( // 广场
            leading: Icon(Icons.question_answer),
            title: Text(S
                .of(context)
                .sideMenuSquare),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ArticlePageWithToolbar(
                loadArticle: (int pageNo){
                  return WanRepository().getSquareArticle(pageNo);
                },
                title: S.of(context).menu_square,
              )));
            },
          ),
          ListTile( // 设置
            leading: Icon(Icons.settings),
            title: Text(S
                .of(context)
                .sideMenuSettings),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SettingPage()));
            },
          ),
          _getLogoutMenu(context, accountModel)
        ],
      ),
    );
  }

}
