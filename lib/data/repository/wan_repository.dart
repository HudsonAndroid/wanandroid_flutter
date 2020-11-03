
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/data/entity/wan_banner.dart';

class Api {
  static const int SUCCESS = 0;
  static const String BANNER = "https://www.wanandroid.com/banner/json";
  static const String TOP_ARTICLE = "https://www.wanandroid.com/article/top/json";
  static const String HOME_ARTICLE = "https://www.wanandroid.com/article/list/{pageNo}/json";
}

class WanRepository {
  static PersistCookieJar _cookieJar;
  static Dio _dio;

  /// 持久化Cookie数据
  // 注意，如果是get方法，方法名不需要添加()
  Future<PersistCookieJar> get cookieJar async {
    if(_cookieJar == null){
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      _cookieJar = PersistCookieJar(dir: appDocPath);
    }
    return _cookieJar;
  }

  Future<Dio> get dio async {
    if(_dio == null) {
      _dio = Dio();
      _dio.interceptors.add(CookieManager(await cookieJar));
    }
    return _dio;
  }

  // 异步方法会把结果包装成Future返回
  Future<List<WanBanner>> banner() async {
    var response = await (await dio).get(Api.BANNER);
    // if the request occur exception, the following code won't run, so we needn't to check it's status
    return BannerWrapper.fromJson(jsonDecode(response.toString())).data;
    // if(response.statusCode == HttpStatus.ok){
    // }
    // return new Future.error('error, the reason is ${response.statusCode}');
  }

  Future<List<WanArticle>> _topArticle() async {
    var response = await (await dio).get(Api.TOP_ARTICLE);
    return TopArticle.fromJson(jsonDecode(response.toString())).data;
  }

  /// 获取首页文章列表， 参数pageNo是页码
  Future<ArticleListWrapper> homePageArticle(int pageNo) async {
    assert(pageNo >= 0);
    List<WanArticle> preList;
    if(pageNo == 0){
      // 需要获取置顶文章
      preList = await _topArticle();
    }
    var response = await (await dio).get(Api.HOME_ARTICLE.replaceAll('{pageNo}', pageNo.toString()));
    ArticleResultWrapper resultWrapper = ArticleResultWrapper.fromJson(jsonDecode(response.toString()));
    if(preList != null){
      preList.addAll(resultWrapper.data.datas);
      resultWrapper.data.datas = preList;
    }
    return resultWrapper.data;
  }
}