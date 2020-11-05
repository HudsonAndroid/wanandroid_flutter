
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/common/common_const_var.dart';
import 'package:wanandroid_flutter/common/state/account_provider.dart';
import 'package:wanandroid_flutter/data/entity/user_info.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/common/round_button.dart';
import 'package:wanandroid_flutter/ui/common/span_text.dart';
import 'package:wanandroid_flutter/ui/page/register_page.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => LoginState();

}

class LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false; // 我们通过控制它来控制校验用户输入
  // 注意： TextFormField的initialValue并不能通过setState来控制，
  // 相关问题见 https://stackoverflow.com/questions/58053956/setstate-does-not-update-textformfield-when-use-initialvalue
  // 解决方案见 https://stackoverflow.com/questions/59929329/why-does-the-initialvalue-not-update-and-display
  // String _defaultUserName;
  TextEditingController _userNameController = TextEditingController();
  String _userName, _password;
  bool _obscurePwd = true; // 密码是否圆点显示

  _initDefaultUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String defaultUser = prefs.getString(AccountProvider.KEY_LAST_LOGIN_USER);
    // 获取上次登录成功的用户名，并自动填入
    setState(() {
      // _defaultUserName = defaultUser;
      _userNameController.text = defaultUser;
    });
  }

  @override
  void initState() {
    _initDefaultUserName();
    super.initState();
  }

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
                        controller: _userNameController,
                        // initialValue: _defaultUserName,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
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
                          icon: Icon(Icons.lock),
                          labelText: S.of(context).action_input_password,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePwd
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePwd = !_obscurePwd;
                              });
                            },
                          )
                        ),
                        obscureText: _obscurePwd,
                        validator: (content) => content.length == 0 ? S.of(context).tips_password_empty : null,
                        onSaved: (value){
                          _password = value;
                        },
                      ),
                      SizedBox(height: 50,),
                      // 登录按钮部分
                      RoundButton(
                        onPressed: (){
                          _validateInput(context, accountModel);
                        },
                        text: S.of(context).action_login,
                      ),
                      SpanText(
                        margin: EdgeInsets.only(top: 20),
                        onTap: (){
                          _goToRegister();
                        },
                        total: S.of(context).tips_no_account,
                        span: S.of(context).action_register,
                      )
                    ],
                  ),
                ),
              ),
            ),
      )
    );
  }

  _goToRegister() async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
    // 获取注册完成的用户名，并自动填入用户名输入框
    setState(() {
      _userNameController.text = result;
    });
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
    var duration = const Duration(milliseconds: ConstVar.COMMON_SNACK_BAR_DURATION);
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