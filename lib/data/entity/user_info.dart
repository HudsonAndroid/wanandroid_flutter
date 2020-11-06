
import 'dart:ffi';

import 'package:wanandroid_flutter/data/entity/base_result.dart';

class LoginResult extends BaseResult{
  UserInfo data;

  LoginResult.fromJson(Map<String, dynamic> json)
    : data = json['data'] == null ? null : UserInfo.fromJson(json['data']), super.fromJson(json);

  @override
  String toString() {
    return 'LoginResult{data: $data}';
  }
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


  @override
  String toString() {
    return 'UserInfo{admin: $admin, coinCount: $coinCount, collectIds: $collectIds, email: $email, icon: $icon, id: $id, nickname: $nickname, password: $password, publicName: $publicName, token: $token, type: $type, username: $username}';
  }

  Map<String, dynamic> toJson() => {
    'admin': admin,
    'coinCount': coinCount,
    'collectIds': collectIds,
    'email': email,
    'icon': icon,
    'id': id,
    'nickname': nickname,
    'password': password,
    'publicName': publicName,
    'token': token,
    'type': type,
    'username': username,
  };
}