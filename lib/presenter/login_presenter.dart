import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertestapp/boilerplates/presenter.dart';
import 'package:fluttertestapp/boilerplates/view.dart';
import 'package:fluttertestapp/component/toast.dart';
import 'package:fluttertestapp/engine/engine_auth.dart';
import 'package:fluttertestapp/pages/home/MainScreen.dart';
import 'package:fluttertestapp/utilities/routing.dart';

class LoginPresenter extends Presenter {

  TextEditingController _userNameController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  LoginPresenter(BuildContext context, View<StatefulWidget> view) : super(context, view);

  @override
  void init() {
    // TODO: implement init
  }

  TextEditingController get passwordController => _passwordController;

  TextEditingController get userNameController => _userNameController;

  void login(){
    view.process(() async {
      String username = _userNameController.text ?? "";
      String password = _passwordController.text ?? "";


      if (username == "") {
        Toast.showToast(context, "Email Address must be filled!");
        return;
      }

      if (password == "") {
        Toast.showToast(context, "Password must be filled!");
        return;
      }
      bool isLogin =  await APIRequest.user.login(context);

      if(isLogin)
        Routing.pushAndRemoveUntil(context, MainScreen(), (_)=>false);
    });
  }

}