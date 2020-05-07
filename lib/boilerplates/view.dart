import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertestapp/utilities/localization.dart';



abstract class View<T extends StatefulWidget> extends State<T> {
  bool _firstRun = true;
  PertaminaDict _dict;
  bool _withLoading = true;
  LoadingController controller = LoadingController();

  PertaminaDict get dict => _dict;

  bool get isPacked => true;


  @override
  void dispose() {
    widgetsBindingRemove();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    widgetsBindingAdd();
  }

  @override
  Widget build(BuildContext context) {
    _dict = PertaminaDict.of(context);

    if (_firstRun) {
      initStateWithContext(context);
      _firstRun = false;
    }
    updateDataWhenStateChange();

//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      print("view postFrame");
//      if (!_barrierIsOn && max > 0) {
//        Navigator.of(context).push(_BarrierRoute(tutorial: this));
//        _barrierIsOn = true;
//      }
//      viewRefreshed();
//    });

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        Widget child =
        orientation == Orientation.portrait ? buildView(
            context) : buildViewLandscape(context);

        return child;
      },
    );
  }

  void updateDataWhenStateChange(){

  }

  void widgetsBindingAdd(){

  }

  void widgetsBindingRemove(){

  }

  void initStateWithContext(BuildContext context) {
  }

  Widget buildView(BuildContext context);

  Widget buildViewLandscape(BuildContext context) {
    return buildView(context);
  }

  void refresh() {
    if (this.mounted) setState(() {});
  }

  Future<dynamic> process(Function f) async {
    OverlayEntry x = _withLoading ? _showLoading() : null;

    var result = await f();

    if (controller.refresh != null) await controller.refresh();

    x?.remove();

    return result;
  }

  OverlayEntry _showLoading() {
    OverlayEntry toastOverlay = _createLoadingOverlay();

    OverlayState overlay = Overlay.of(context);

    if (overlay == null) return null;
    overlay.insert(toastOverlay);

    return toastOverlay;
  }

  OverlayEntry _createLoadingOverlay() {
    return OverlayEntry(
      builder: (context) =>
          FullLoading(
            true,
            Colors.black.withOpacity(0.82),
            64.0,
            64.0,
            controller,
          ),
    );
  }
}

typedef Future<void> RefreshLoading();

class LoadingController {
  RefreshLoading refresh;
}

class FullLoading extends StatefulWidget {
  final bool visible;
  final Color barrierColor;
  final double width;
  final double height;
  final LoadingController controller;

  FullLoading(this.visible, this.barrierColor, this.width, this.height, this.controller);

  @override
  State<StatefulWidget> createState() => FullLoadingState();
}

class FullLoadingState extends State<FullLoading> with TickerProviderStateMixin {
  AnimationController opacityController;

  @override
  void initState() {
    super.initState();
    if (!this.mounted) return;

    widget.controller.refresh = () async {
      if (!opacityController.isDismissed) await opacityController.reverse(from: 1.0);
    };

    opacityController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    opacityController.addListener(() {
      if (this.mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    opacityController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!opacityController.isAnimating) {
        if (widget.visible && opacityController.value == 0.0) opacityController.forward(from: 0.0);
      }
    });

    return Visibility(
      visible: opacityController.value > 0.0,
      child: Positioned.fill(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: Opacity(
                  opacity: opacityController.value,
                  child: Container(
                      color: widget.barrierColor,
                      child: Center(
                          child:
                          CircularProgressIndicator()
//                          Image.asset(
//                            "images/octopus.gif",
//                            height: widget.height,
//                            width: widget.width,
//                          )
                      ))))),
    );
  }
}

//class _BarrierRoute<T> extends PageRoute<T> {
//  _BarrierRoute({
//    @required this.tutorial,
//    this.maintainState = true,
//    this.transitionDuration = const Duration(milliseconds: 60),
//    RouteSettings settings,
//  }) : super(settings: settings);
//
//  final Tutorial tutorial;
//
//  @override
//  final bool maintainState;
//
//  @override
//  final Duration transitionDuration;
//
//  @override
//  Widget buildPage(BuildContext context, Animation<double> animation,
//      Animation<double> secondaryAnimation) {
//    return Material(
//      type: MaterialType.transparency,
//      child: GestureDetector(
//        behavior: HitTestBehavior.opaque,
//        onTapDown: (d) {
//          if (tutorial.allShown) Navigator.pop(context);
//        },
//        child: Center(),
//      ),
//    );
//  }
//
//  @override
//  bool get opaque => false;
//
//  @override
//  Color get barrierColor => null;
//
//  @override
//  String get barrierLabel => null;
//}
