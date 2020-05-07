import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertestapp/pages/home/MainScreen.dart';
import 'package:fluttertestapp/pages/login/LoginScreen.dart';
import 'package:fluttertestapp/utilities/flavor.dart';
import 'package:fluttertestapp/utilities/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application.dart';
import 'component/setup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new PertaminaApp());
  });
}

class PertaminaApp extends StatefulWidget {
  @override
  _PertaminaAppState createState() => _PertaminaAppState();
}

class _PertaminaAppState extends State<PertaminaApp> {
  Locale _locale = Locale("en");
  Widget _widget = LoginScreen();
  SharedPreferences prefs;
  SetupController setupController = SetupController();

  Future<void> getPrefs(BuildContext context) async {
    prefs ??= await SharedPreferences.getInstance();

    if (prefs.getString(kBearerToken) != null) {
      setState(() {
        _widget = MainScreen();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
    application.flavor = flavorDev;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

