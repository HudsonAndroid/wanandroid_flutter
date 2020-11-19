
import 'package:wanandroid_flutter/data/entity/base_result.dart';

// 用户积分
class UserScore {
  int coinCount;
  int level;
  int rank;
  int userId;
  String username;

  UserScore.fromJson(Map<String, dynamic> json)
    : coinCount = json['coinCount'],
      level = json['level'],
      rank = json['rank'],
      username = json['username'],
      userId = json['userId'];
}

class CurrentUserScore extends BaseResult {
  UserScore data;

  CurrentUserScore.fromJson(Map<String, dynamic> json)
      : data = UserScore.fromJson(json['data']),
        super.fromJson(json);
}

// 积分排行
class UserScoreRank {
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;
  int curPage;
  List<UserScore> datas;

  UserScoreRank.fromJson(Map<String, dynamic> json)
    : offset = json['offset'],
      over = json['over'],
      pageCount = json['pageCount'],
      size = json['size'],
      total = json['total'],
      curPage = json['curPage'],
      datas = List<UserScore>.from(json['datas'].map((x) => UserScore.fromJson(x)));
}

class UserScoreRankWrapper extends BaseResult {
  UserScoreRank data;

  UserScoreRankWrapper.fromJson(Map<String, dynamic> json)
      : data = UserScoreRank.fromJson(json['data']),
        super.fromJson(json);

}