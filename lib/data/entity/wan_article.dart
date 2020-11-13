
import 'package:wanandroid_flutter/data/entity/base_result.dart';
import 'package:wanandroid_flutter/ui/page/tree/navigation_page.dart';

class StarArticleResultWrapper extends BaseResult {
  StarArticleListWrapper data;

  StarArticleResultWrapper.fromJson(Map<String, dynamic> json)
      : data = StarArticleListWrapper.fromJson(json['data']), super.fromJson(json);
}

class StarArticleListWrapper {
  int curPage;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;
  List<StarArticle> datas;
  
  StarArticleListWrapper.fromJson(Map<String, dynamic> json)
    : curPage = json['curPage'],
      offset = json['offset'],
      over = json['over'],
      pageCount = json['pageCount'],
      size = json['size'],
      total = json['total'],
      datas = List<StarArticle>.from(json['datas'].map((x) => StarArticle.fromJson(x)));
}

/// 收藏文章一项实体数据
class StarArticle {
  int id;
  String author;
  int chapterId;
  String chapterName;
  int courseId;
  String desc;
  String envelopePic;
  String link;
  String niceDate;
  String origin;
  int originId;
  int publishTime;
  String title;
  int userId;
  int visible;
  int zan;

  StarArticle.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        author = json['author'],
        chapterId = json['chapterId'],
        chapterName = json['chapterName'],
        courseId = json['courseId'],
        desc = json['desc'],
        envelopePic = json['envelopePic'],
        link = json['link'],
        niceDate = json['niceDate'],
        origin = json['origin'],
        originId = json['originId'],
        publishTime = json['publishTime'],
        title = json['title'],
        userId = json['userId'],
        visible = json['visible'],
        zan = json['zan'];
}

/// 一般情况下的文章
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

  // 用于判定集合中是否包含有WanArticle时只判断id即可（因为部分页面文章返回字段有多有少）
  // 判定对象是否相等见https://stackoverflow.com/questions/29567322/how-does-a-set-determine-that-two-objects-are-equal-in-dart
  @override
  bool operator ==(Object other)
    => other is WanArticle && id == other.id;

  // 重写hashcode方法参考自 https://stackoverflow.com/questions/20577606/whats-a-good-recipe-for-overriding-hashcode-in-dart
  // 由于这里只涉及一个参数，因此没有使用到
  @override
  int get hashCode => id.hashCode;

  /// don't modify it, it's used in [NavigationPage]
  @override
  String toString() {
    return title;
  }
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
class TopArticle extends BaseResult{
  List<WanArticle> data;

  TopArticle.fromJson(Map<String, dynamic> json)
      : data = List<WanArticle>.from(json['data'].map((x) => WanArticle.fromJson(x))), super.fromJson(json);
}

// 一般情况服务器返回的文章列表，即外面还包裹了一层
class ArticleResultWrapper extends BaseResult{
  ArticleListWrapper data;

  ArticleResultWrapper.fromJson(Map<String, dynamic> json)
    : data = ArticleListWrapper.fromJson(json['data']), super.fromJson(json);
}

/// 文章一页实际数据
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