
import 'dart:async';


import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:fluttertestapp/boilerplates/view.dart';
import 'package:fluttertestapp/utilities/layout_helper.dart';

import '../application.dart';


typedef Future<void> Fetcher();
typedef Future<void> OnInit(BuildContext context);
typedef Future<String> MinVer();
typedef Future<String> LatestVer();
typedef Future<void> NotifOnMessage(Map<String, dynamic> message);
typedef Future<void> NotifOnResume(Map<String, dynamic> message);
typedef Future<void> NotifOnLaunch(Map<String, dynamic> message);
typedef Future<void> NotifTokenRefresh(BuildContext context, String token);
typedef Future<void> OnRetrieveDynamicLink(BuildContext context);
typedef void NotifInit(BuildContext context);
typedef void OnLink(BuildContext context, Uri deepLink);

enum Status {
  failed,
  success,
  processing,
  canUpdate,
  mustUpdate,
  failedGetMinVersion,
  failedGetLatestVersion
}

typedef Widget UiBuilder(BuildContext context, double processing, String description, Status type);

class Setup extends StatefulWidget {
  final List<NavigatorObserver> observer;
  final ThemeData theme;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final NotifOnMessage notifOnMessage;
  final NotifOnResume notifOnResume;
  final NotifOnLaunch notifOnLaunch;
  final NotifTokenRefresh notifTokenRefresh;
  final Fetcher fetcher;
  final MinVer minVer;
  final LatestVer latestVer;
  final SetupController controller;
  final UiBuilder uiBuilder;
  final OnInit onInit;
  final OnLink onLink;
  final int totalApiRequest;

  const Setup(
      {this.observer = const [],
      this.theme,
      this.localizationsDelegates,
      this.notifOnLaunch,
      this.notifOnMessage,
      this.notifOnResume,
      this.notifTokenRefresh,
      this.fetcher,
      this.minVer,
      this.latestVer,
      @required this.uiBuilder,
      this.onInit,
      this.onLink,
      @required this.totalApiRequest,
      SetupController controller})
      : assert(controller != null),
        this.controller = controller;

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends View<Setup> with WidgetsBindingObserver {
  Status statusNow;
  String minVer;
  bool isDataFetched = false;
  bool isRetrieveDynamicLink = false;

//  BuildContext builderContext; // context yang sudah isi material app

  @override
  Widget buildView(BuildContext context) {
    if (LayoutHelper.screenWidth == null) {
      Size size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
      LayoutHelper.screenWidth = size.width;
      LayoutHelper.screenHeight = size.height;
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: widget.observer,
      localizationsDelegates: widget.localizationsDelegates,
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('id', 'ID'), // Hebrew
      ],
      theme: widget.theme,
      home: Builder(builder: (context) {
        Widget uiBuilder;
        uiBuilder = widget.uiBuilder(
            context, widget.controller.progress, widget.controller.description, statusNow);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _getData();
        });

        return PHome(uiBuilder);
      }),
    );
  }

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    if (widget.onInit != null) widget.onInit(context);
//    application.onLink = widget.onLink;
//    application.onNotif = _initNotif;

    widget.controller.addListener(_update);
    widget.controller.setupState = this;
    widget.controller._totalApiRequest = widget.totalApiRequest;
  }

  void _initNotif(BuildContext context) {
//    NotificationHelper.init(
//        onMessage: widget.notifOnMessage,
//        onLaunch: widget.notifOnLaunch,
//        onResume: widget.notifOnResume,
//        onTokenRefresh: (tokenRefresh) => widget.notifTokenRefresh(context, tokenRefresh));
  }

  void _settingInitialLink() async {
//    Uri initialUri;
//    try {
//      initialUri = await getInitialUri();
//      print('initial uri: ${initialUri?.path}'
//          ' ${initialUri?.queryParametersAll}');
//      if (initialUri == null) return;
//      var context = await application.completer.future;
////      Toast.showToast(context, "FromInitialUri : $initialUri");
//      application.onLink(context, initialUri);
//    } on PlatformException {
//      initialUri = null;
//    } on FormatException {
//      initialUri = null;
//    }
  }

  void _getData() {
    if (!isDataFetched) {
      isDataFetched = true;

      if(widget.fetcher!=null){
        statusNow = Status.processing;
        widget.fetcher();
      } else {
        setState(() {
          statusNow = Status.success;
          _settingInitialLink();
        });
      }
    }
  }

  void _retry() {
    setState(() {
      if (statusNow == Status.failed) {
        isDataFetched = false;
      } else if (statusNow == Status.failedGetMinVersion) {
        _fetchMinVersion();
      } else if (statusNow == Status.failedGetLatestVersion) {
        _fetchLatestVersion();
      }
      statusNow = Status.processing;
    });
  }

  void _updateApps() {
//    SingleShareHelper.updateApps(context);
  }

  void _fetchMinVersion() {
    widget.minVer().then((result) {
      if (result == null) {
        setState(() {
          statusNow = Status.failedGetMinVersion;
        });
      } else {
        minVer = result;
        _fetchLatestVersion();
      }
    });
  }

  void _fetchLatestVersion() {
    widget.latestVer().then((latestVerResult) {
      if (latestVerResult == null) {
        setState(() {
          statusNow = Status.failedGetLatestVersion;
        });
      } else {
        _checkVersion(minVer, latestVerResult).then((result) {
          setState(() {
            statusNow = result;
            if (statusNow == Status.success) _settingInitialLink();
          });
        });
      }
    });
  }

  void _update() {
    if (widget.controller.progress == 1.0) {
      if (widget.controller.checkDataIsNotValid()) {
        setState(() {
          statusNow = Status.failed;
        });
      } else {
        if (widget.minVer != null && widget.latestVer != null) {
          _fetchMinVersion();
        } else {
          setState(() {
            statusNow = Status.success;
            _settingInitialLink();
//            _initNotif();
          });
        }
      }
    } else {
      setState(() {
        statusNow = Status.processing;
      });
    }
  }

  Future<Status> _checkVersion(String minVersion, String latestVersion) async {
//    int minVerFromServer = int.tryParse(minVersion.substring(minVersion.indexOf("+") + 1, minVersion.length));
//    int latestVerFromServer =
//    int.tryParse(latestVersion.substring(latestVersion.indexOf("+") + 1, latestVersion.length));
//    PackageInfo packageInfo = await PackageInfo.fromPlatform();
//    int versionFromLocal = int.tryParse(packageInfo.buildNumber);
//
//    if (versionFromLocal < minVerFromServer) {
//      return Status.mustUpdate;
//    } else if (versionFromLocal < latestVerFromServer) {
//      return Status.canUpdate;
//    } else {
//      return Status.success;
//    }
  }
}

class PHome extends StatefulWidget {
  final Widget child;

  PHome(this.child);

  @override
  _PHomeState createState() => _PHomeState();
}

class _PHomeState extends View<PHome> {
//  Timer _timerLink;
  BuildContext buildContext;
  String _latestLink = 'Unknown';
  Uri _latestUri;


  @override
  Widget buildView(BuildContext context) {
    if (!application.completer.isCompleted)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("Proses : $context");
        if (!application.completer.isCompleted) application.completer.complete(Future.value(context));
      });

    return widget.child;
  }


  void _settingDynamicOnLink() async {
//    StreamSubscription _sub;
//    _sub = getUriLinksStream().listen((Uri uri) {
//
//    });
//
//    getUriLinksStream().listen((Uri uri) {
//
//    });
  }

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _settingDynamicOnLink();
//    application.onNotif(context);
  }
}

class SetupController extends ValueNotifier<SetupEditingValue> {
  double get progress => value.progress;

  String get description => value.description;

  bool get isError => value.isError;

  List<bool> get apiResultList => _apiResult;

  _SetupState setupState;

  int _totalApiRequest;

  List<bool> _apiResult = [];

  void retry() {
    _apiResult.clear();
    setupState._retry();
  }

  void updateApps() {
    setupState._updateApps();
  }

  void updateProgress(String description, bool isGetDataSuccess) {
//    assert(progress >= 0.0 && progress <= 1.0);
    _apiResult.add(isGetDataSuccess);
    double progress = _apiResult.length / _totalApiRequest;
    value =
        value.copyWith(description: description, progress: progress, isError: !isGetDataSuccess);
  }

  bool checkDataIsNotValid() {
    return _apiResult.contains(false);
  }

  SetupController({double progress, String description, bool isError})
      : super(progress == null && description == null && isError == null
            ? SetupEditingValue.empty
            : new SetupEditingValue(
                progress: progress, description: description, isError: isError));

  SetupController.fromValue(SetupEditingValue value) : super(value ?? SetupEditingValue.empty);

  void clear() {
    value = SetupEditingValue.empty;
  }
}

@immutable
class SetupEditingValue {
  const SetupEditingValue(
      {this.progress = 0.0, this.description = "", this.isError = false, this.setupState});

  final double progress;
  final String description;
  final bool isError;
  final _SetupState setupState;

  static const SetupEditingValue empty = const SetupEditingValue();

  SetupEditingValue copyWith(
      {double progress,
      String description,
      bool isError,
      _SetupState setupState,
      List<bool> apiResultList}) {
    return new SetupEditingValue(
        progress: progress, description: description, isError: isError, setupState: setupState);
  }

  SetupEditingValue.fromValue(SetupEditingValue copy)
      : this.progress = copy.progress,
        this.description = copy.description,
        this.isError = copy.isError,
        this.setupState = copy.setupState;

  @override
  String toString() =>
      '$runtimeType(progress: \u2524$progress\u251C, description: \u2524$description\u251C, isError: \u2524$isError\u251C)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! SetupEditingValue) return false;
    final SetupEditingValue typedOther = other;
    return typedOther.progress == progress &&
        typedOther.description == description &&
        typedOther.isError == isError;
  }

  @override
  int get hashCode => hashValues(progress.hashCode, description.hashCode, isError.hashCode);
}
