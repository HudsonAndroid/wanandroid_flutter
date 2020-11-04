
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/data/entity/user_info.dart';

class AccountProvider with ChangeNotifier {
  static const String KEY_LOGIN_CACHE = "login_cache";
  UserInfo userInfo;

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
    }
  }

  changeCurrentUser(UserInfo newUser) async{
    userInfo = newUser;
    notifyListeners();
    // save cache
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if newUser is null, will clean the cache
    prefs.setString(KEY_LOGIN_CACHE, jsonEncode(newUser.toJson()));
  }

  isLogin() => userInfo != null;
}