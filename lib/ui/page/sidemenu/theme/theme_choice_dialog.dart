
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/common/state/theme_manager.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/common/radio_group.dart';

/// 主题切换对话框
class ThemeChoiceDialog extends StatelessWidget{

  RadioModel _createRadioModel(BuildContext context, ThemeManager themeManager, ThemeMode mode){
    return RadioModel(ThemeManager.getThemeDesc(context, mode), mode,
        selected: themeManager.themeMode == mode);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    List<RadioModel> selections = [
      _createRadioModel(context, themeManager, ThemeMode.light),
      _createRadioModel(context, themeManager, ThemeMode.dark),
      _createRadioModel(context, themeManager, ThemeMode.system)
    ];
    double itemHeight = 60.0;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: itemHeight * (selections.length + 1),
        width: 300.0,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: Text(S.of(context).action_switch_theme, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            Container(
              height: itemHeight * selections.length,
              child: RadioGroup(selections, itemHeight: itemHeight, onSelectChange: (RadioModel model){
                themeManager.setThemeMode(model.label);
              }),
            )
          ],
        ),
      ),
    );
  }

}