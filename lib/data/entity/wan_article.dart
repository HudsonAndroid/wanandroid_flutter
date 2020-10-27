
import 'dart:ffi';

import 'package:wanandroid_flutter/data/entity/base_result.dart';

class WanArticle {
  int id;
  String author;
  bool canEdit;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String envelopePic;
  bool fresh;
  String link;
  String niceDate;
  String niceShareDate;
  String origin;
  int realSuperChapterId;
  String shareUser;
  int superChapterId;
  String superChapterName;
  List<Tag> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;

  WanArticle.fromJson(Map<String, dynamic> json)
    : id = json['id'],
    author = json['author'],
    canEdit = json['canEdit'],
    chapterId = json['chapterId'],
    chapterName = json['chapterName'],
    collect = json['collect'],
    courseId = json['courseId'],
    desc = json['desc'],
    envelopePic = json['envelopePic'],
    fresh = json['fresh'],
    link = json['link'],
    niceDate = json['niceDate'],
    niceShareDate = json['niceShareDate'],
    origin = json['origin'],
    realSuperChapterId = json['realSuperChapterId'],
    shareUser = json['shareUser'],
    superChapterId = json['superChapterId'],
    superChapterName = json['superChapterName'],
    tags = List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
    title = json['title'],
    type = json['type'],
    userId = json['userId'],
    visible = json['visible'],
    zan = json['zan'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'author': author,
    'canEdit': canEdit,
    'chapterId': chapterId,
    'chapterName': chapterName,
    'collect': collect,
    'courseId': courseId,
    'desc': desc,
    'envelopePic': envelopePic,
    'fresh': fresh,
    'link': link,
    'niceDate': niceDate,
    'niceShareDate': niceShareDate,
    'origin': origin,
    'realSuperChapterId': realSuperChapterId,
    'shareUser': shareUser,
    'superChapterId': superChapterId,
    'superChapterName': superChapterName,
    'tags': tags,
    'title': title,
    'type': type,
    'userId': userId,
    'visible': visible,
    'zan': zan,
  };
}

class Tag {
  String name;
  String url;

  Tag.fromJson(Map<String, dynamic> json)
    : name = json['name'],
    url = json['url'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
  };
}

// 置顶文章，服务器返回的结果
class TopArticle {
  List<WanArticle> data;

  TopArticle.fromJson(Map<String, dynamic> json)
      : data = List<WanArticle>.from(json['data'].map((x) => WanArticle.fromJson(x)));
}

// 一般情况服务器返回的文章列表，即外面还包裹了一层
class ArticleResultWrapper {
  ArticleListWrapper data;

  ArticleResultWrapper.fromJson(Map<String, dynamic> json)
    : data = ArticleListWrapper.fromJson(json['data']);
}

class ArticleListWrapper {
  int curPage;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;
  List<WanArticle> datas;

  ArticleListWrapper.fromJson(Map<String, dynamic> json)
    : curPage = json['curPage'],
    offset = json['offset'],
    over = json['over'],
    pageCount = json['pageCount'],
    size = json['size'],
    total = json['total'],
    datas = List<WanArticle>.from(json['datas'].map((x) => WanArticle.fromJson(x)));
}