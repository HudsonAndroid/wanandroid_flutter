
import 'dart:convert';
import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/data/entity/base_result.dart';
import 'package:wanandroid_flutter/data/entity/user_info.dart';
import 'package:wanandroid_flutter/data/entity/user_score.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';

/// 账号系统，目前收藏的列表是通过SharedPreferences存储的，更合理的操作的话，应该让
/// 数据库存储
class AccountProvider with ChangeNotifier {
  static const String KEY_LOGIN_CACHE = "login_cache";
  static const String KEY_LAST_LOGIN_USER = "last_login";
  static const String KEY_SCORE_CACHE = "score_cache";
  UserInfo userInfo;
  UserScore userScore;

  AccountProvider(){
    initUserInfo();
  }

  initUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String infoJson = prefs.getString(KEY_LOGIN_CACHE);
    if(infoJson != null){
      userInfo = UserInfo.fromJson(jsonDecode(infoJson));
      // now we should notify to listeners.
      notifyListeners();
      autoLogin();
    }
  }

  // 如果之前登录过，首次打开自动登录一次，以获取最新的用户收藏列表（避免由于在其他设备操作，导致数据过旧）
  autoLogin() async {
    // 获取在Repository中登录时加密存储的账号密码数据
    var crypt = AesCrypt(WanRepository.ACCOUNT_CRYPT_PASSWORD);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String aesFile = appDocDir.path + WanRepository.ACCOUNT_CRYPT_FILE;
    try{
      var account = await crypt.decryptTextFromFile(aesFile);
      if(account != null){
        var array = account.split(' ');
        if(array.length == 2){
          LoginResult result = await WanRepository().login(array[0], array[1], false);
          if(result.isSuccess()){
            changeCurrentUser(result.data);
          }
        }
      }
    } on FileSystemException catch(e){
      // maybe not login before, it will invoke FileSystemException, do nothing.
      print('$e, you can ignore it if you do not login account before.');
    }
  }

  changeCurrentUser(UserInfo newUser) async{
    userInfo = newUser;
    notifyListeners();
    // save cache
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if newUser is null, will clean the cache
    prefs.setString(KEY_LOGIN_CACHE, newUser == null ? null : jsonEncode(newUser.toJson()));
    // 如果登录成功了，则保存记录，以便下次进入登录页面时默认填入用户名
    if(newUser != null){
      prefs.setString(KEY_LAST_LOGIN_USER, newUser.username);
    }
  }
  
  bool isArticleStared(int id) {
    return userInfo == null ? false : userInfo.collectIds.contains(id);
  }

  Future<bool> starOrReverseArticle(bool isNowStared, int id) async {
    if(!isLogin()){
      return false;
    }
    BaseResult result;
    var repository = WanRepository();
    if(isNowStared){
      result = await repository.unStarArticle(id);
    }else{
      result = await repository.starArticle(id);
    }
    if(result.isSuccess()){
      // if it's successful, we should update local collectIds
      if(!isNowStared){
        userInfo.collectIds.add(id);
      }else{
        userInfo.collectIds.remove(id);
      }
      // 同步信息到持久性容器中。或许可以优化，不是每次操作都同步，类似android jetpack的 WorkManager定期处理
      _sync2Persistent();
    }
    return result.isSuccess();
  }

  // 同步账号信息到SharedPreferences
  _sync2Persistent() async {
    if(userInfo == null) return ;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_LOGIN_CACHE, jsonEncode(userInfo));
  }

  /// 获取用户积分情况
  Future<UserScore> getUserScore({bool forceUpdate = false}) async {
    if(!isLogin()) return null;
    if(userScore != null && !forceUpdate) return userScore;
    // try to fetch network data
    try{
      UserScore score = await WanRepository().getCurrentUserScore();
      if(score != null){
        // save it if fetch successfully
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(userInfo.id.toString(), jsonEncode(score));
        userScore = score;
        notifyListeners();
      }
      return score;
    }catch(e){
      print(e);
      // if fetch failed, try to check SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result = prefs.getString(userInfo.id.toString());
      if(result == null) return null;
      UserScore score = UserScore.fromJson(jsonDecode(result));
      if(score != null){
        userScore = score;
        notifyListeners();
      }
      return score;
    }
  }

  isLogin() => userInfo != null;
}