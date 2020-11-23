
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/common/list_page_wrapper.dart';

class RankPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(S.of(context).score_rank_page),
        ),
        body: ListPageWrapper(
            startPage: 0,
            loadPage: (int pageNo){
                return WanRepository().getUserScoreRank(pageNo);
            },
            itemWidgetHolder: (index, entity, {OnItemDelete onItemDelete}) {
                var textStyle = _getHonourStyle(index);
                return Container(
                  height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 15),
                        Text('${index + 1}', style: textStyle,),
                        SizedBox(width: 20),
                        Text('${entity.username}', style: textStyle),
                        Expanded(child: SizedBox(),),
                        Text('${entity.coinCount}',  style: textStyle),
                        SizedBox(width: 15)
                      ],
                    ),
                );
            },
        ),
    );
  }

  TextStyle _getHonourStyle(int rank) {
    if(rank == 0){
      return TextStyle(color: Colors.amber);
    }else if(rank == 1){
      return TextStyle(color: Colors.white70);
    }else if(rank == 2){
      return TextStyle(color: const Color(0xFFCA9956));
    }
    return TextStyle();
  }


}