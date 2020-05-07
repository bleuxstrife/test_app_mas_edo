import 'package:flutter/material.dart';
import 'package:fluttertestapp/utilities/slide_left_route.dart';

class Routing {
  static Future<T> pushReplacement<T extends Object>(BuildContext context, Widget widget) async {
    var result = await Navigator.pushReplacement(
      context,
      SlideLeftRoute(widget: widget, settings: RouteSettings(name: widget.runtimeType.toString())),
    );
    return result;
  }

  static Future<T> push<T extends Object>(BuildContext context, Widget widget) async {
    var result = await Navigator.push(
      context,
      SlideLeftRoute(widget: widget, settings: RouteSettings(name: widget.runtimeType.toString())),
    );
    return result;
  }

  static Future<T> pushAndRemoveUntil<T extends Object>(BuildContext context, Widget widget, RoutePredicate predicate) async {
    String routeName = widget.runtimeType.toString();

    if (routeName == "HomePage") routeName = "/";

    var result = await Navigator.pushAndRemoveUntil(context,
        SlideLeftRoute(widget: widget, settings: RouteSettings(name: routeName)), predicate);
    return result;
  }
}
