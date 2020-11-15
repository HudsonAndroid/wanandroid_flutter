
import 'package:wanandroid_flutter/data/entity/base_result.dart';

class SearchWord {
  int id;
  String link;
  String name;
  int order;
  int visible;

  SearchWord.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      link = json['link'],
      name = json['name'],
      order = json['order'],
      visible = json['visible'];

  @override
  String toString() {
    return name;
  }
}

class SearchWordWrapper extends BaseResult {
  List<SearchWord> data;

  SearchWordWrapper.fromJson(Map<String, dynamic> json) :
      data = List<SearchWord>.from(json['data'].map((x) => SearchWord.fromJson(x))),
        super.fromJson(json);

}