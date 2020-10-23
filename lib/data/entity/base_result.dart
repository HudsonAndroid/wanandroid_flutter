
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';

class BaseResult {
  int errorCode;
  String errorMsg;

  bool isSuccess() => errorCode == Api.SUCCESS;
}