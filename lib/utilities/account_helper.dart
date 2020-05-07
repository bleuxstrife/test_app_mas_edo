import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertestapp/pages/login/LoginScreen.dart';
import 'package:fluttertestapp/utilities/pref_keys.dart';
import 'package:fluttertestapp/utilities/routing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountHelper {
  static Future<void> saveUserInfo(String username, Map result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(kUsername, username);
    prefs.setString(kRefreshToken, result["refresh_token"]);
    prefs.setString(kBearerToken, result["access_token"]);
  }


  static Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(kUsername);
    prefs.remove(kBearerToken);
    Routing.pushAndRemoveUntil(context, LoginScreen(), (_) => false);
  }

  static Future<void> tokenExpired(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Information"),
          content: new Text("Your session has ended, please login again"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) async {
      await AccountHelper.logOut(context);
    });
  }
}
