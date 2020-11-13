
import 'package:wanandroid_flutter/data/entity/base_result.dart';
import 'package:wanandroid_flutter/ui/page/tree/tree_page.dart';

class Category {
  List<Category> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  Category.fromJson(Map<String, dynamic> json)
    : courseId = json['courseId'],
      children = List<Category>.from(json['children'].map((x) => Category.fromJson(x))),
      id = json['id'],
      name = json['name'],
      order = json['order'],
      parentChapterId = json['parentChapterId'],
      userControlSetTop = json['userControlSetTop'],
      visible = json['visible'];

  /// don't modify it, because it's used in [TreePage]
  @override
  String toString() {
    return name;
  }
}

class CategoryWrapper extends BaseResult {
  List<Category> data;

  CategoryWrapper.fromJson(Map<String, dynamic> json)
      : data = List<Category>.from(json['data'].map((x) => Category.fromJson(x))),
        super.fromJson(json);
}