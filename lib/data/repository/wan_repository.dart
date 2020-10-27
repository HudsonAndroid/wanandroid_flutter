
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/data/entity/wan_banner.dart';

class Api {
  static const int SUCCESS = 0;
  static const String BANNER = "https://www.wanandroid.com/banner/json";
  static const String TOP_ARTICLE = "https://www.wanandroid.com/article/top/json";
  static const String HOME_ARTICLE = "https://www.wanandroid.com/article/list/{pageNo}/json";
}

class WanRepository {

  // 异步方法会把结果包装成Future返回
  Future<List<WanBanner>> banner() async {
    var response = await Dio().get(Api.BANNER);
    if(response.statusCode == HttpStatus.ok){
      return BannerWrapper.fromJson(jsonDecode(response.toString())).data;
    }
    return new Future.error('error, the reason is ${response.statusCode}');
  }

  Future<List<WanArticle>> topArticle() async {
    var response = await Dio().get(Api.TOP_ARTICLE);
    if(response.statusCode == HttpStatus.ok){
      return TopArticle.fromJson(jsonDecode(response.toString())).data;
    }
    return new Future.error('error, the reason is ${response.statusCode}');
  }

  /// 获取首页文章列表， 参数pageNo是页码
  Future<ArticleListWrapper> homePageArticle(int pageNo) async {
    assert(pageNo >= 0);
    List<WanArticle> preList;
    if(pageNo == 0){
      // 需要获取置顶文章
      preList = await topArticle();
    }
    var response = await Dio().get(Api.HOME_ARTICLE.replaceAll('{pageNo}', pageNo.toString()));
    if(response.statusCode == HttpStatus.ok){
      ArticleResultWrapper resultWrapper = ArticleResultWrapper.fromJson(jsonDecode(response.toString()));
      if(preList != null){
        preList.addAll(resultWrapper.data.datas);
        resultWrapper.data.datas = preList;
      }
      return resultWrapper.data;
    }
    return new Future.error('error, the reason is ${response.statusCode}');
  }
}