
import 'package:wanandroid_flutter/data/entity/base_result.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';

class NavigationItem {
  int cid;
  String name;
  List<WanArticle> articles;

  NavigationItem.fromJson(Map<String, dynamic> json)
    : cid = json['cid'],
      name = json['name'],
      articles = List<WanArticle>.from(json['articles'].map((x)=> WanArticle.fromJson(x)));
}

class NavigationWrapper extends BaseResult {
  List<NavigationItem> data;

  NavigationWrapper.fromJson(Map<String, dynamic> json)
      : data = List<NavigationItem>.from(json['data'].map((x) => NavigationItem.fromJson(x))),
        super.fromJson(json);

}