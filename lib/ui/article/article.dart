
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wanandroid_flutter/common/WebUtil.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/ui/common/round_rectangle.dart';

class Article extends StatefulWidget {
  final WanArticle _article;

  Article(this._article);

  @override
  State<StatefulWidget> createState() => ArticleState();
}

/// 文章列表的一项
class ArticleState extends State<Article> {

  /// 创建文章图片
  Widget buildIcon(String imgLink) {
    if(imgLink?.isNotEmpty == true){
      return Container(
        width: 115,
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: imgLink,
          fit: BoxFit.fill,
        ),
      );
    }
    return Container(width: 0,);
  }

  /// 决定是否创建新文章标识
  Widget buildNewFlag(bool isNew){
    if(isNew){
      return RoundRectangle(radius: 6.0, color: Colors.red, text: '新');
    }
    return Container();
  }

  /// 决定是否创建置顶标识
  Widget buildTopFlag(bool isTop){
    if(isTop){
      return RoundRectangle(radius: 6.0, color: Colors.purple, text: '置顶',);
    }
    return Container();
  }

  String getNiceAuthor(){
    if(widget._article.author?.isEmpty == true){
      return widget._article.shareUser;
    }
    return widget._article.author;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        // 直接跳转到指定网页
        jumpWeb(widget._article.link);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(6.0, 9.0, 6.0, 9.0),
        child: Row(
          children: <Widget>[
            // 图标部分 外部嵌套一层Container目的是为了设置图标的大小
            buildIcon(widget._article.envelopePic),
            Expanded(
              child: Column(
                children: <Widget>[
                  // 顶部
                  Row(
                    children: <Widget>[
                      buildTopFlag(widget._article.type == 1),
                      buildNewFlag(widget._article.fresh),
                      SizedBox(width: 6.0,),
                      Text(getNiceAuthor(), style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text(widget._article.niceDate, style: TextStyle(fontSize: 13.0, color: Colors.grey),),
                      SizedBox(width: 6.0,)
                    ],
                  ),
                  // 标题部分
                  Html(
                    padding: EdgeInsets.fromLTRB(6.0, 5.0, 6.0, 0),
                    data: widget._article.title,
                    defaultTextStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  // 分类部分
                  Html(
                    padding: EdgeInsets.fromLTRB(6.0, 5.0, 6.0, 5.0),
                    data: widget._article.superChapterName + "/" + widget._article.chapterName,
                    defaultTextStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

}