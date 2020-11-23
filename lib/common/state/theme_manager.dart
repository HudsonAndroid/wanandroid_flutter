import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';

/// 主题管理
/// system 0   light 1   dark 2
class ThemeManager with ChangeNotifier{
  static const String USER_THEME = "userTheme";
  final lightTheme = ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      unselectedWidgetColor: Colors.black87
  );

  final darkTheme = ThemeData.dark().copyWith(
    unselectedWidgetColor: Colors.grey,
  );

  ThemeMode themeMode = ThemeMode.system;

  ThemeManager(){
    initUserTheme();
  }

  initUserTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeType = prefs.getInt(USER_THEME);
    _assignTheme(themeType);
  }

  _assignTheme(int themeType){
    if(themeType == 1){
      themeMode = ThemeMode.light;
    }else if(themeType == 2){
      themeMode = ThemeMode.dark;
    }else{
      themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  int _getThemeCode(){
    if(themeMode == ThemeMode.light){
      return 1;
    }else if(themeMode == ThemeMode.dark){
      return 2;
    }else{
      return 0;
    }
  }

  static String getThemeDesc(BuildContext context, ThemeMode mode) {
    if(mode == ThemeMode.light) {
      return S.of(context).theme_mode_light;
    }else if(mode == ThemeMode.dark) {
      return S.of(context).theme_mode_dark;
    }else{
      return S.of(context).theme_mode_system;
    }
  }

  void setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(USER_THEME, _getThemeCode());
  }

}