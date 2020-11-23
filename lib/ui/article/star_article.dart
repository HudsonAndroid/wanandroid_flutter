
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wanandroid_flutter/common/common_util.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/common/list_page_wrapper.dart';

/// 收藏文章布局的一项，比普通文章多了originId，且取消收藏方式不同；另外没有置顶等标识。为了避免
/// 混乱，单独弄成一个
class StarArticleItem extends StatelessWidget {
  final StarArticle _article;
  final OnItemDelete onItemDelete;
  final int listIndex;

  StarArticleItem(this._article, this.onItemDelete, this.listIndex);

  /// 创建文章图片
  Widget buildIcon(String imgLink) {
    if(imgLink?.isNotEmpty == true){
      return Container(
        width: 115,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: imgLink,
            fit: BoxFit.fill,
          ),
        ),
      );
    }
    return Container(width: 0);
  }


  String getNiceAuthor(){
    if(_article.author?.isEmpty == true){
      return "";
    }
    return _article.author;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible( // Dismissible可以参考这里https://medium.com/@maffan/how-to-make-a-dismissible-listview-in-flutter-a9f730a751be
      onDismissed: (DismissDirection direction) {
        onItemDelete(listIndex);
      },
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      secondaryBackground: Container(
        padding: EdgeInsets.only(right: 20),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(S.of(context).action_delete, style: TextStyle(color: Colors.white)),
        ),
        color: Colors.red,
      ),
      background: Container(),
      child: InkWell(
          onTap: (){
            // 直接跳转到指定网页
            jumpWeb(_article.link);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(6.0, 9.0, 6.0, 9.0),
            child: Row(
              children: <Widget>[
                // 图标部分 外部嵌套一层Container目的是为了设置图标的大小
                buildIcon(_article.envelopePic),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      // 顶部
                      Row(
                        children: <Widget>[
                          SizedBox(width: 6.0,),
                          Text(getNiceAuthor(), style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Text(_article.niceDate, style: TextStyle(fontSize: 13.0, color: Colors.grey),),
                          SizedBox(width: 6.0,)
                        ],
                      ),
                      // 标题部分
                      Html(
                        padding: EdgeInsets.fromLTRB(6.0, 5.0, 6.0, 0),
                        data: _article.title,
                        defaultTextStyle: TextStyle(fontSize: 16.0),
                      ),
                      // 分类部分
                      Html(
                        padding: EdgeInsets.fromLTRB(6.0, 5.0, 6.0, 5.0),
                        data: _article.chapterName,
                        defaultTextStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
