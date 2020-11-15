
import 'dart:convert';
import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wanandroid_flutter/data/entity/base_result.dart';
import 'package:wanandroid_flutter/data/entity/category.dart';
import 'package:wanandroid_flutter/data/entity/navigation_item.dart';
import 'package:wanandroid_flutter/data/entity/user_info.dart';
import 'package:wanandroid_flutter/data/entity/wan_article.dart';
import 'package:wanandroid_flutter/data/entity/wan_banner.dart';

class Api {
  static const int SUCCESS = 0;
  static const String BANNER = "https://www.wanandroid.com/banner/json";
  static const String TOP_ARTICLE = "https://www.wanandroid.com/article/top/json";
  static const String HOME_ARTICLE = "https://www.wanandroid.com/article/list/{pageNo}/json";
  static const String LOGIN = "https://www.wanandroid.com/user/login";
  static const String LOGOUT = "https://www.wanandroid.com/user/logout/json";
  static const String REGISTER = "https://www.wanandroid.com/user/register";
  static const String STAR_ARTICLE = "https://www.wanandroid.com/lg/collect/{id}/json";
  static const String UN_STAR_ARTICLE = "https://www.wanandroid.com/lg/uncollect_originId/{id}/json";
  static const String STAR_ARTICLES = "https://www.wanandroid.com/lg/collect/list/{pageNo}/json";
  static const String WX_CATEGORY = "https://www.wanandroid.com/wxarticle/chapters/json";
  static const String WX_ARTICLE = "https://www.wanandroid.com/wxarticle/list/{wechatId}/{pageNo}/json";
  static const String PROJECT_CATEGORY = "https://www.wanandroid.com/project/tree/json";
  static const String PROJECT_ARTICLE = "https://www.wanandroid.com/article/list/{pageNo}/json";
  static const String TREE_CATEGORY = "https://www.wanandroid.com/tree/json";
  static const String TREE_ARTICLE = "https://www.wanandroid.com/article/list/{pageNo}/json";
  static const String NAVIGATION_LIST = "https://www.wanandroid.com/navi/json";
}

// 由于WanAndroid服务端请求会返回一个SessionId（会话id）【本APP中运行时每次请求后，服务端并没有返回新的SessionId，在PostMan中试验时会返回新的SessionId】，
// 而且如果客户端请求使用了旧的会话id，返回的数据是没有任何变动的（即使用户收藏了某篇文章，即collect变成true; 或者反向操作），
// 因此有必要避免使用旧的会话id，以获取最新数据
// 所以自定义CookieManager逻辑
class MyCookieManager extends CookieManager{
  MyCookieManager(CookieJar cookieJar): super(cookieJar);

  @override
  Future onResponse(Response response) async => _saveCookies(response);

  @override
  Future onError(DioError err) async => _saveCookies(err.response);

  _saveCookies(Response response) {
    if (response != null && response.headers != null) {
      List<String> cookies = response.headers[HttpHeaders.setCookieHeader];
      if (cookies != null) {
        cookies = _removeSessionId(cookies);
        List<Cookie> cookiesList = cookies.map((str)  {
          return Cookie.fromSetCookieValue(str);
        }).toList();
        cookieJar.saveFromResponse(
          response.request.uri,
          cookiesList,
        );
      }
    }
  }

  // 移除会话的SessionId，以使服务器创建一个新的会话，原因是如果使用旧的，会导致用户的操作（例如收藏）不会同步过来
  // 经过测试验证，由于服务端每次请求都会创建一个SessionId，而如果一直使用同一个SessionId，重新获取数据时用户操作
  // 将不会同步（服务端返回的数据还是旧数据）可能这是服务端的一个问题。
  // 因此，由客户端控制，禁用SessionId。
  List<String> _removeSessionId(List<String> cookies) {
    int index = 0;
    for(int i = 0; i < cookies.length; i++){
      if(cookies[i].contains('JSESSIONID')){
        index = i;
        break;
      }
    }
    cookies.removeAt(index);
    return cookies;
  }
}

class WanRepository {
  static const String ACCOUNT_CRYPT_PASSWORD = "hudson666";
  static const String ACCOUNT_CRYPT_FILE = '/account_cache.aes';
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
      _dio.interceptors.add(MyCookieManager(await cookieJar));
      // 网络请求日志监听器，建议正式环境关闭
      _dio.interceptors.add(LogInterceptor(responseHeader: false));
    }
    return _dio;
  }

  // 异步方法会把结果包装成Future返回
  // 备注：这里把dio实例使用新建的实例访问，原因是使用_dio实例请求的情况下
  // 会出现有banner, top article, home article同时请求，且中间有个
  // top article的请求莫名出现返回的数据不是正常的用户数据（有收藏，返回没有收藏）的问题
  // 因此Banner的请求更换成普通新实例(因为他不需要cookieJar信息)
  Future<List<WanBanner>> banner() async {
    var response = await new Dio().get(Api.BANNER);
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

  /// 登录post
  Future<LoginResult> login(String userName, String password, [savePassword = true]) async {
    FormData formData = FormData.fromMap({
      "username": userName,
      "password": password
    });
    var response = await (await dio).post(Api.LOGIN, data: formData);
    LoginResult result = LoginResult.fromJson(jsonDecode(response.toString()));
    if(savePassword && result.isSuccess()){
      // 加密账号密码并缓存起来
      var crypt = AesCrypt(ACCOUNT_CRYPT_PASSWORD);
      crypt.setOverwriteMode(AesCryptOwMode.on);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      // 存储的位置在 /data/data/{package name}/app_flutter/ 目录下
      String aesFile = appDocDir.path + ACCOUNT_CRYPT_FILE;
      crypt.encryptTextToFile('$userName $password', aesFile);
    }
    return result;
  }

  Future<BaseResult> logout() async {
    var response = await (await dio).get(Api.LOGOUT);
    return BaseResult.fromJson(jsonDecode(response.toString()));
  }

  Future<BaseResult> register(String userName, String password, String confirm) async {
    FormData formData = FormData.fromMap({
      "username": userName,
      "password": password,
      "repassword": confirm
    });
    var response = await (await dio).post(Api.REGISTER, data: formData);
    return BaseResult.fromJson(jsonDecode(response.toString()));
  }

  Future<BaseResult> starArticle(int id) async {
    var response = await (await dio).post(Api.STAR_ARTICLE.replaceAll('{id}', id.toString()));
    return BaseResult.fromJson(jsonDecode(response.toString()));
  }

  Future<BaseResult> unStarArticle(int id) async {
    var response = await (await dio).post(Api.UN_STAR_ARTICLE.replaceAll('{id}', id.toString()));
    return BaseResult.fromJson(jsonDecode(response.toString()));
  }

  Future<StarArticleResultWrapper> getStarArticles(int pageNo) async {
    var response = await (await dio).get(Api.STAR_ARTICLES.replaceAll('{pageNo}', pageNo.toString()));
    return StarArticleResultWrapper.fromJson(jsonDecode(response.toString()));
  }

  // 获取微信tab分类列表（不包含页面数据）
  Future<List<Category>> getWxCategory() async {
    var response = await (await dio).get(Api.WX_CATEGORY);
    return CategoryWrapper.fromJson(jsonDecode(response.toString())).data;
  }

  // 获取微信文章列表
  Future<ArticleListWrapper> getWxArticles(int wechatId, int pageNo) async {
    var response = await (await dio).get(Api.WX_ARTICLE
          .replaceAll('{wechatId}', wechatId.toString())
          .replaceAll('{pageNo}', pageNo.toString()));
    return ArticleResultWrapper.fromJson(jsonDecode(response.toString())).data;
  }

  // 获取项目tab分类列表（不包含页面数据）
  Future<List<Category>> getProjectCategory() async {
    var response = await (await dio).get(Api.PROJECT_CATEGORY);
    return CategoryWrapper.fromJson(jsonDecode(response.toString())).data;
  }

  // 获取项目文章列表
  Future<ArticleListWrapper> getProjectArticles(int projectId, int pageNo) async {
    var response = await (await dio).get(
        Api.PROJECT_ARTICLE.replaceAll('{pageNo}', pageNo.toString()),
        queryParameters: {'cid': projectId}
    );
    return ArticleResultWrapper.fromJson(jsonDecode(response.toString())).data;
  }

  // 获取体系列表
  Future<CategoryWrapper> getTreeCategory() async {
    var response = await (await dio).get(Api.TREE_CATEGORY);
    return CategoryWrapper.fromJson(jsonDecode(response.toString()));
  }

  // 获取指定体系的文章列表
  Future<ArticleListWrapper> getTreeArticles(int treeId, int pageNo) async {
    var response = await (await dio).get(
        Api.TREE_ARTICLE.replaceAll('{pageNo}', pageNo.toString()),
        queryParameters: {'cid': treeId}
    );
    return ArticleResultWrapper.fromJson(jsonDecode(response.toString())).data;
  }

  // 获取导航结果列表
  Future<NavigationWrapper> getNavigationList() async {
    var response = await (await dio).get(Api.NAVIGATION_LIST);
    return NavigationWrapper.fromJson(jsonDecode(response.toString()));
  }
}