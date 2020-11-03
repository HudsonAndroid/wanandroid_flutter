
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/common/state/account_provider.dart';
import 'package:wanandroid_flutter/data/entity/user_info.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => LoginState();

}

class LoginState extends State<LoginPage> {
  static const int _DURATION = 2000;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false; // 我们通过控制它来控制校验用户输入
  String _userName, _password;

  @override
  Widget build(BuildContext context) {
    final accountModel = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).action_login),
      ),
      body: Builder(
        builder: (context) =>
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate, // TextFormField本身可以自己又这个属性，这里统一由Form控制
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: S.of(context).action_input_user_name
                        ),
                        validator: (content) => content.length == 0 ? S.of(context).tips_user_name_empty : null,
                        onSaved: (value){
                          _userName = value;
                        },
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: S.of(context).action_input_password
                        ),
                        obscureText: true,
                        validator: (content) => content.length == 0 ? S.of(context).tips_password_empty : null,
                        onSaved: (value){
                          _password = value;
                        },
                      ),
                      SizedBox(height: 50,),
                      // SeparateButton(onPress: _validateInput,)
                      RaisedButton(
                        onPressed: (){
                          _validateInput(context, accountModel);
                        },
                        child: Text(S.of(context).action_login),
                      )
                    ],
                  ),
                ),
              ),
            ),
      )
    );
  }

  _validateInput(BuildContext context, AccountProvider accountModel) {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      _login(context, accountModel);
    }else{
      _autoValidate = true;
    }
  }

  // 注意，这里的context不能使用默认构建的context，否则会报错误Scaffold.of() called with a context that does not contain a Scaffold
  // 问题发生在 提供的context刚好来自与widget的构建函数实际要寻找的Scaffold的小部件的状态相同的StatefulWidget时
  // 问题相关参考： https://medium.com/@ksheremet/flutter-showing-snackbar-within-the-widget-that-builds-a-scaffold-3a817635aeb2
  // 更多： https://stackoverflow.com/questions/51304568/scaffold-of-called-with-a-context-that-does-not-contain-a-scaffold
  _login(BuildContext context, AccountProvider accountModel) async {
    LoginResult result = await WanRepository().login(_userName, _password);
    var duration = const Duration(milliseconds: _DURATION);
    if(result.isSuccess()){
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: duration,
        content: Text(S.of(context).tips_login_success),
      ));
      accountModel.changeCurrentUser(result.data);
      Future.delayed(duration, (){
        Navigator.pop(context);
      });
    }else{
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: duration,
        content: Text('${S.of(context).tips_login_failed}${result.errorMsg}'),
      ));
    }
  }

}