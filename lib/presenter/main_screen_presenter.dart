import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertestapp/boilerplates/presenter.dart';
import 'package:fluttertestapp/boilerplates/view.dart';
import 'package:fluttertestapp/models/user.dart';

class MainScreenPresenter extends Presenter{
  UserProfileModel _userProfileModel;

  MainScreenPresenter(BuildContext context, View<StatefulWidget> view, UserProfileModel userProfileModel) : super(context, view){
      this._userProfileModel = userProfileModel;
  }

  @override
  void init() {
    // TODO: implement init
  }

  UserProfileModel get userProfileModel => _userProfileModel;


}