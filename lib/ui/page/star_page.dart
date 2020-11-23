
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/common/state/account_provider.dart';
import 'package:wanandroid_flutter/data/entity/base_result.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/article/star_article.dart';
import 'package:wanandroid_flutter/ui/common/list_page_wrapper.dart';

class StarPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final accountModel = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).my_star_article_page),
      ),
      body: ListPageWrapper(
        startPage: 0,
        loadPage: (int pageNo){
          return WanRepository().getStarArticles(pageNo);
        },
        itemWidgetHolder: (index, entity, {OnItemDelete onItemDelete}){
          return StarArticleItem(entity, onItemDelete, index);
        },
        tryToDelete: (int index, entity) async {
          try{
            BaseResult result = await WanRepository().unStarArticleByStarId(entity.id, entity.originId ?? -1);
            if(result.isSuccess() && entity.originId != null){
              return await accountModel.starOrReverseArticle(true, entity.originId, shouldNotify: true);
            }
          }catch(e){
            print(e);
          }
          return false;
        },
      ),
    );
  }

}