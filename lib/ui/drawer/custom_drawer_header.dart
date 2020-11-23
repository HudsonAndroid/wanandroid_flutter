
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/common/state/account_provider.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/common/round_button.dart';
import 'package:wanandroid_flutter/ui/drawer/user_avatar.dart';
import 'package:wanandroid_flutter/ui/page/rank_page.dart';

/// 用户头部信息
class CustomDrawerHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AccountProvider accountModel = Provider.of<AccountProvider>(context);
    accountModel.getUserScore();
    return DrawerHeader(
      decoration: BoxDecoration(
          color: Theme
              .of(context)
              .primaryColor
      ),
      child: _getDrawerHeader(context, accountModel),
    );
  }

  Widget _getDrawerHeader(BuildContext context, AccountProvider accountModel) {
    var boldTitleStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);
    if (accountModel.isLogin()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            child: UserAvatar(),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 70,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(accountModel.userInfo.username, style: boldTitleStyle),
                        RoundButton(
                          height: 24,
                          text: accountModel.userScore == null ? 'Lv.0' : 'Lv.${accountModel.userScore.level}',
                          bgColor: Colors.teal,
                          borderColor: Colors.teal,
                          margin: EdgeInsets.only(left: 10),
                          roundRadius: 6,
                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => RankPage()));
                      },
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset("assets/icon_rank.svg", width: 30, height: 30, color: Colors.deepOrange,),
                          Text('${accountModel.userScore == null ? 0 : accountModel.userScore.rank}'),
                          Expanded(child: SizedBox(),),
                          SvgPicture.asset("assets/icon_coin.svg", width: 30, height: 30, color: Colors.deepOrange),
                          Text('${accountModel.userScore == null ? 0 : accountModel.userScore.coinCount}'),
                          Expanded(child: SizedBox(),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
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

}
