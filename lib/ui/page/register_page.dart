
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/common_const_var.dart';
import 'package:wanandroid_flutter/data/entity/base_result.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/common/round_button.dart';

class RegisterPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => RegisterState();

}

class RegisterState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false; // 我们通过控制它来控制校验用户输入
  String _userName, _password, _confirm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).action_register),
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
                        ),
                        obscureText: true,
                        validator: (content) => content.length == 0 ? S.of(context).tips_password_empty : null,
                        onSaved: (value){
                          _password = value;
                        },
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: S.of(context).tips_confirm_password,
                        ),
                        obscureText: true,
                        validator: (content) => content.length == 0 ? S.of(context).tips_password_empty : null,
                        onSaved: (value){
                          _confirm = value;
                        },
                      ),
                      SizedBox(height: 50,),
                      // 登录按钮部分
                      RoundButton(
                        onPressed: (){
                          _validateInput(context);
                        },
                        text: S.of(context).action_register,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      )
    );
  }

  _validateInput(BuildContext context) {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      _register(context);
    }else{
      _autoValidate = true;
    }
  }
  
  _register(BuildContext context) async {
    BaseResult result = await WanRepository().register(_userName, _password, _confirm);
    var duration = const Duration(milliseconds: ConstVar.COMMON_SNACK_BAR_DURATION);
    if(result.isSuccess()){
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: duration,
        content: Text(S.of(context).tips_register_success),
      ));
      Future.delayed(duration, (){
        Navigator.pop(context, _userName);// 携带用户名返回
      });
    }else{
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: duration,
        content: Text('${S.of(context).tips_register_failed}，${result.errorMsg}'),
      ));
    }
  }

}