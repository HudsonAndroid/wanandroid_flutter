
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/common/common_util.dart';
import 'package:wanandroid_flutter/common/state/account_provider.dart';
import 'package:wanandroid_flutter/data/entity/user_score.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/common/round_button.dart';

/// 用户头部信息
class CustomDrawerHeader extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CustomDrawerHeaderState();

}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  UserScore userScore;

  @override
  void initState() {
    super.initState();
    _loadUserScore();
  }

  _loadUserScore() async {
    userScore = await WanRepository().getCurrentUserScore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AccountProvider accountModel = Provider.of<AccountProvider>(context);
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
          CircleAvatar(
            radius: 36.0,
            backgroundImage: AssetImage(
                assetsImg('icon_default_user', fileType: 'jpg')),
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
                            text: userScore == null ? 'lv.0' : 'lv.${userScore.level}',
                            bgColor: Colors.teal,
                            margin: EdgeInsets.only(left: 10),
                            roundRadius: 6,
                            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/icon_rank.svg", width: 30, height: 30, color: Colors.deepOrange,),
                        Text('${userScore == null ? 0 : userScore.rank}'),
                        Expanded(child: SizedBox(),),
                        SvgPicture.asset("assets/icon_coin.svg", width: 30, height: 30, color: Colors.deepOrange),
                        Text('${userScore == null ? 0 : userScore.coinCount}'),
                        Expanded(child: SizedBox(),)
                      ],
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