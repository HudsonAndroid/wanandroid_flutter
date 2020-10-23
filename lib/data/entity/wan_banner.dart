
import 'package:wanandroid_flutter/data/entity/base_result.dart';

class WanBanner {
  String title;
  int id;
  String url;
  String imagePath;

  WanBanner.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      id = json['id'],
      url = json['url'],
      imagePath = json['imagePath'];


  Map<String, dynamic> toJson() => {
    'title': title,
    'id': id,
    'url': url,
    'imagePath': imagePath,
  };
}

// 复杂数据类json转换处理方式
// see https://stackoverflow.com/questions/55710579/how-to-parse-complex-json-in-flutter
class BannerWrapper extends BaseResult {
  List<WanBanner> data;

  BannerWrapper.fromJson(Map<String, dynamic> json)
    : data = List<WanBanner>.from(json['data'].map((x) => WanBanner.fromJson(x)));
}