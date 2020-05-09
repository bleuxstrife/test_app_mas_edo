import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertestapp/pages/home/MainScreen.dart';
import 'package:fluttertestapp/pages/login/LoginScreen.dart';
import 'package:fluttertestapp/utilities/flavor.dart';
import 'package:fluttertestapp/utilities/localization.dart';
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

  Widget _buildUi(BuildContext context, double processing, String description,
      Status type) {
    switch (type) {
      case Status.success:
        return PHome(_widget);
        break;
      default:
        return _buildProcessing(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Setup(
      observer: const <NavigatorObserver>[],
      controller: setupController,
      onInit: getPrefs,
//      onLink: _onDynamicLink,
      localizationsDelegates: [
        TimerLocalizationsDelegate(overriddenLocale: _locale),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      uiBuilder: _buildUi,
      totalApiRequest: 0,
      theme: new ThemeData(
//          appBarTheme: AppBarTheme(
//            color: global.systemAccentColor,
//          ),
//          brightness: Brightness.light,
//          primarySwatch: CompanyColors.primary,
//          primaryColor: CompanyColors.primary[0],
//          primaryColorBrightness: Brightness.light,
//          accentColor: CompanyColors.accent[500],
//          scaffoldBackgroundColor: CompanyColors.primary[0],
//          fontFamily: "Roboto",
          accentColorBrightness: Brightness.light
      ),
//      notifOnLaunch: notifOnLaunch,
//      notifOnMessage: notifOnMessage,
//      notifOnResume: notifOnResume,
//      notifTokenRefresh: notifTokenRefresh,
    );
  }

  Widget _buildProcessing(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: CircularProgressIndicator(
            value: 20.0,
          )),
    );
  }
}

