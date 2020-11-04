// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "action_input_password" : MessageLookupByLibrary.simpleMessage("please input account password"),
    "action_input_user_name" : MessageLookupByLibrary.simpleMessage("please input user name"),
    "action_login" : MessageLookupByLibrary.simpleMessage("login account"),
    "action_logout" : MessageLookupByLibrary.simpleMessage("退出登录"),
    "appName" : MessageLookupByLibrary.simpleMessage("WanAndroid"),
    "flag_new" : MessageLookupByLibrary.simpleMessage("new"),
    "flag_top" : MessageLookupByLibrary.simpleMessage("top"),
    "homePage" : MessageLookupByLibrary.simpleMessage("Home"),
    "loadMore" : MessageLookupByLibrary.simpleMessage("load more"),
    "noMoreData" : MessageLookupByLibrary.simpleMessage("no more data"),
    "sideMenuAsk" : MessageLookupByLibrary.simpleMessage("ask"),
    "sideMenuSettings" : MessageLookupByLibrary.simpleMessage("settings"),
    "sideMenuSquare" : MessageLookupByLibrary.simpleMessage("square"),
    "tips_error_retry" : MessageLookupByLibrary.simpleMessage("load failed, click me to retry"),
    "tips_login_failed" : MessageLookupByLibrary.simpleMessage("login failed, the reason is "),
    "tips_login_success" : MessageLookupByLibrary.simpleMessage("login success"),
    "tips_need_login" : MessageLookupByLibrary.simpleMessage("please login first"),
    "tips_password_empty" : MessageLookupByLibrary.simpleMessage("password cannot be empty"),
    "tips_user_name_empty" : MessageLookupByLibrary.simpleMessage("user name cannot be empty"),
    "wechatPage" : MessageLookupByLibrary.simpleMessage("WeChatArticle")
  };
}
