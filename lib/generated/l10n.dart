// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `WanAndroid`
  String get appName {
    return Intl.message(
      'WanAndroid',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homePage {
    return Intl.message(
      'Home',
      name: 'homePage',
      desc: '',
      args: [],
    );
  }

  /// `WeChatArticle`
  String get wechatPage {
    return Intl.message(
      'WeChatArticle',
      name: 'wechatPage',
      desc: '',
      args: [],
    );
  }

  /// `load more`
  String get loadMore {
    return Intl.message(
      'load more',
      name: 'loadMore',
      desc: '',
      args: [],
    );
  }

  /// `no more data`
  String get noMoreData {
    return Intl.message(
      'no more data',
      name: 'noMoreData',
      desc: '',
      args: [],
    );
  }

  /// `ask`
  String get sideMenuAsk {
    return Intl.message(
      'ask',
      name: 'sideMenuAsk',
      desc: '',
      args: [],
    );
  }

  /// `square`
  String get sideMenuSquare {
    return Intl.message(
      'square',
      name: 'sideMenuSquare',
      desc: '',
      args: [],
    );
  }

  /// `settings`
  String get sideMenuSettings {
    return Intl.message(
      'settings',
      name: 'sideMenuSettings',
      desc: '',
      args: [],
    );
  }

  /// `new`
  String get flag_new {
    return Intl.message(
      'new',
      name: 'flag_new',
      desc: '',
      args: [],
    );
  }

  /// `top`
  String get flag_top {
    return Intl.message(
      'top',
      name: 'flag_top',
      desc: '',
      args: [],
    );
  }

  /// `load failed, click me to retry`
  String get tips_error_retry {
    return Intl.message(
      'load failed, click me to retry',
      name: 'tips_error_retry',
      desc: '',
      args: [],
    );
  }

  /// `please login first`
  String get tips_need_login {
    return Intl.message(
      'please login first',
      name: 'tips_need_login',
      desc: '',
      args: [],
    );
  }

  /// `login account`
  String get action_login {
    return Intl.message(
      'login account',
      name: 'action_login',
      desc: '',
      args: [],
    );
  }

  /// `please input user name`
  String get action_input_user_name {
    return Intl.message(
      'please input user name',
      name: 'action_input_user_name',
      desc: '',
      args: [],
    );
  }

  /// `user name cannot be empty`
  String get tips_user_name_empty {
    return Intl.message(
      'user name cannot be empty',
      name: 'tips_user_name_empty',
      desc: '',
      args: [],
    );
  }

  /// `please input account password`
  String get action_input_password {
    return Intl.message(
      'please input account password',
      name: 'action_input_password',
      desc: '',
      args: [],
    );
  }

  /// `password cannot be empty`
  String get tips_password_empty {
    return Intl.message(
      'password cannot be empty',
      name: 'tips_password_empty',
      desc: '',
      args: [],
    );
  }

  /// `login success`
  String get tips_login_success {
    return Intl.message(
      'login success',
      name: 'tips_login_success',
      desc: '',
      args: [],
    );
  }

  /// `login failed, the reason is `
  String get tips_login_failed {
    return Intl.message(
      'login failed, the reason is ',
      name: 'tips_login_failed',
      desc: '',
      args: [],
    );
  }

  /// `logout`
  String get action_logout {
    return Intl.message(
      'logout',
      name: 'action_logout',
      desc: '',
      args: [],
    );
  }

  /// `sorry, logout failed`
  String get tips_logout_failed {
    return Intl.message(
      'sorry, logout failed',
      name: 'tips_logout_failed',
      desc: '',
      args: [],
    );
  }

  /// `no account? go to register`
  String get tips_no_account {
    return Intl.message(
      'no account? go to register',
      name: 'tips_no_account',
      desc: '',
      args: [],
    );
  }

  /// `register`
  String get action_register {
    return Intl.message(
      'register',
      name: 'action_register',
      desc: '',
      args: [],
    );
  }

  /// `please confirm password`
  String get tips_confirm_password {
    return Intl.message(
      'please confirm password',
      name: 'tips_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `register success`
  String get tips_register_success {
    return Intl.message(
      'register success',
      name: 'tips_register_success',
      desc: '',
      args: [],
    );
  }

  /// `register failed`
  String get tips_register_failed {
    return Intl.message(
      'register failed',
      name: 'tips_register_failed',
      desc: '',
      args: [],
    );
  }

  /// `ProjectArticle`
  String get projectPage {
    return Intl.message(
      'ProjectArticle',
      name: 'projectPage',
      desc: '',
      args: [],
    );
  }

  /// `tree`
  String get tree_sub_tree {
    return Intl.message(
      'tree',
      name: 'tree_sub_tree',
      desc: '',
      args: [],
    );
  }

  /// `navigation`
  String get tree_sub_navi {
    return Intl.message(
      'navigation',
      name: 'tree_sub_navi',
      desc: '',
      args: [],
    );
  }

  /// `Tree`
  String get treePage {
    return Intl.message(
      'Tree',
      name: 'treePage',
      desc: '',
      args: [],
    );
  }

  /// `search`
  String get action_search {
    return Intl.message(
      'search',
      name: 'action_search',
      desc: '',
      args: [],
    );
  }

  /// `Enter keywords, separate multiple keywords with spaces`
  String get tips_search_hint {
    return Intl.message(
      'Enter keywords, separate multiple keywords with spaces',
      name: 'tips_search_hint',
      desc: '',
      args: [],
    );
  }

  /// `hot search`
  String get hot_search {
    return Intl.message(
      'hot search',
      name: 'hot_search',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}