
import 'package:wanandroid_flutter/data/entity/base_result.dart';

class LoginResult extends BaseResult{
  UserInfo data;

  LoginResult.fromJson(Map<String, dynamic> json)
    : data = UserInfo.fromJson(json), super.fromJson(json);
}

class UserInfo {
  bool admin;
  int coinCount;
  List<int> collectIds;
  String email;
  String icon;
  int id;
  String nickname;
  String password;
  String publicName;
  String token;
  int type;
  String username;

  UserInfo.fromJson(Map<String, dynamic> json)
    : admin = json['admin'],
    coinCount = json['coinCount'],
    collectIds = json['collectIds'] == null ? null : List<int>.from(json['collectIds'].map((x) => x)),
    email = json['email'],
    icon = json['icon'],
    id = json['id'],
    nickname = json['nickname'],
    password = json['password'],
    publicName = json['publicName'],
    token = json['token'],
    type = json['type'],
    username = json['username'];
}