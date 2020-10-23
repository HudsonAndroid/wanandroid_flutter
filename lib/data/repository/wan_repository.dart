
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wanandroid_flutter/data/entity/wan_banner.dart';

class Api {
  static const int SUCCESS = 0;
  static const String BANNER = "https://www.wanandroid.com/banner/json";
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
}