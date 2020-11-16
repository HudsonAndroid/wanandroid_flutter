
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/ui/page/article_page.dart';

class ArticlePageWithToolbar extends StatelessWidget {
  final LoadArticle loadArticle;
  final int startPage;
  final String title;

  ArticlePageWithToolbar({
    Key key,
    this.loadArticle,
    this.startPage = 0,
    this.title
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ArticlePage(loadArticle: loadArticle, startPage: startPage),
    );
  }

}