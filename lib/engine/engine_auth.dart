library engine;

import 'dart:async';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertestapp/component/toast.dart';
import 'package:fluttertestapp/models/user.dart';
import 'package:fluttertestapp/utilities/account_helper.dart';
import 'package:fluttertestapp/utilities/localization.dart';
import 'package:fluttertestapp/utilities/log_helper.dart';
import 'package:fluttertestapp/utilities/pref_keys.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../application.dart';


part 'user.dart';

part 'sales.dart';


enum RequestType { get, delete, post, put }

class APIRequest {
  static _User user = _User();
  static _Sales sales = _Sales();
}

abstract class PertaminaEngine {
  String get tag;

  static int maxRetry = 10;
  static int timeOutDuration = 30000;

//  static String dynamicLink = application.flavor.dynamicLink;
  static String baseUrl = application.flavor.endPoint;

  Future<Options> _getDioOptions({bool needToken = false}) async {
    Map<String, String> header = needToken ? await _createHeaderWithToken() : _createHeader();

    return Options(
      headers: header,
      validateStatus: (statusCode) => statusCode == 200,
//      contentType: Headers.jsonContentType,
    );
  }

  Future<Options> _getDioOptionsWithTimeout({bool needToken = false}) async {
    Map<String, String> header = needToken ? await _createHeaderWithToken() : _createHeader();

    return Options(
        sendTimeout: timeOutDuration,
        receiveTimeout: timeOutDuration,
        headers: header,
//        contentType: Headers.jsonContentType,
        validateStatus: (statusCode) => statusCode == 200);
  }

  Future<Options> _getDioOptionsWithRefreshToken() async {
    Map<String, String> header = await _createHeaderWithRefreshToken();

    return Options(headers: header, validateStatus: (statusCode) => statusCode == 200);
  }

  Map<String, String> _createHeader() {
    return {"content-type": "application/json"};
  }

  Future<Map<String, String>> _createHeaderWithToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String bearerToken = (prefs.getString(kBearerToken) ?? "");

    logger.d("bearerToken => $bearerToken");

    return {
      "content-type": "application/json",
      "Authorization": "Bearer $bearerToken",
    };
  }

  Future<Map<String, String>> _createHeaderWithRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String refreshToken = (prefs.getString(kRefreshToken) ?? "");

    logger.d("refreshToken => $refreshToken");

    return {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Bearer $refreshToken",
    };
  }

  Future<Response<dynamic>> _handleError(context, counter, refreshCounter, DioError error, url,
      token, needToken, RequestType requestType, bool withTimeout,
      {var param}) async {
    logger.d("message => ${error.message}");
    logger.d("error => ${error.error}");
    logger.d("type => ${error.type}");
    logger.d("request => ${error.request}");
    logger.d("response => ${error.response}");
    logger.d("url => $url");
    if (error.type == DioErrorType.CONNECT_TIMEOUT || error.type == DioErrorType.RECEIVE_TIMEOUT) {
      if (counter < maxRetry) {
        counter++;
        Toast.showToast(context, "Request Timed Out ($counter)");
        if (requestType == RequestType.post) {
          return await _post(
            context: context,
            url: url,
            param: param,
            lastCounter: counter,
            refreshCounter: refreshCounter,
            token: token,
            needToken: needToken,
            withTimeout: withTimeout,
          );
        } else if (requestType == RequestType.put) {
          return await _put(
            context: context,
            url: url,
            param: param,
            lastCounter: counter,
            refreshCounter: refreshCounter,
            token: token,
            needToken: needToken,
            withTimeout: withTimeout,
          );
        } else if (requestType == RequestType.get) {
          return await _get(
            context: context,
            url: url,
            lastCounter: counter,
            refreshCounter: refreshCounter,
            token: token,
            needToken: needToken,
            withTimeout: withTimeout,
          );
        } else if (requestType == RequestType.delete) {
          return await _delete(
            context: context,
            url: url,
            lastCounter: counter,
            refreshCounter: refreshCounter,
            token: token,
            needToken: needToken,
            withTimeout: withTimeout,
          );
        }
      } else {
        Toast.showToast(context, "Request timed out after attempt to connect 10 times!");

        return null;
      }
    } else {
      if (CancelToken.isCancel(error)) {
        Toast.showToast(context, "Request Canceled: ${error.message}");
        return null;
      } else {
        if (error.response != null) {
          if (error.response.statusCode == 401 && error.request.path.contains("auth/login")) {
            Toast.showToast(context, "Username or password invalid");
          } else if(error.response.statusCode == 401 ){
            AccountHelper.tokenExpired(context);
          } else {
            Toast.showToast(context, "Error: ${error.message}");
          }
//          if (error.response.data["error"] != null) {
//            Toast.showToast(context, "Error: ${error.response.data["error"]}");
//          } else if (error.response.data["error_codes"] != null &&
//              error.response.data["error_codes"][0] == "TOKEN_EXPIRED") {
//            String tokenUrl = baseUrl + "/user/login/refresh";
//            var uri = Uri.parse(tokenUrl);
//            var tokenResult = await _post(
//              context: context,
//              url: uri.toString(),
//              needToken: true,
//              token: token,
//              options: await _getDioOptionsWithRefreshToken(),
//            );
//
////            AccountHelper.renewToken(tokenResult.data);
//
//            var result;
//
//            if (requestType == RequestType.post) {
//              result = await _post(
//                context: context,
//                url: url,
//                param: param,
//                lastCounter: counter,
//                refreshCounter: refreshCounter,
//                token: token,
//                needToken: needToken,
//                withTimeout: withTimeout,
//              );
//            } else if (requestType == RequestType.put) {
//              result = await _put(
//                context: context,
//                url: url,
//                param: param,
//                lastCounter: counter,
//                refreshCounter: refreshCounter,
//                token: token,
//                needToken: needToken,
//                withTimeout: withTimeout,
//              );
//            } else if (requestType == RequestType.get) {
//              result = await _get(
//                context: context,
//                url: url,
//                lastCounter: counter,
//                refreshCounter: refreshCounter,
//                token: token,
//                needToken: needToken,
//                withTimeout: withTimeout,
//              );
//            } else if (requestType == RequestType.delete) {
//              result = await _delete(
//                context: context,
//                url: url,
//                lastCounter: counter,
//                refreshCounter: refreshCounter,
//                token: token,
//                needToken: needToken,
//                withTimeout: withTimeout,
//              );
//            }
//
//            logger.d("on [$tag], ($url) produces after refresh token\n$result}");
//
//            return result;
//          } else {
//            if (error.response.data.runtimeType == String) {
//              Toast.showToast(context, "Error:Type error salah\n${error.response.data}");
//            } else {
//              Toast.showToast(context, "Error:\n${error.response.data}");
//            }
//          }
        } else {
          Toast.showToast(context, "Error: ${error.message}");
        }
        return null;
      }
    }
  }

//  _checkTokenExpired() async {
//    print("error.response.statusCode => ${error.response.statusCode}");
//    if (error.response != null) {
//      if (error.response.data["error_codes"][0] == "TOKEN_EXPIRED") {
//        String tokenUrl = baseUrl + "/user/login/refresh";
//        var uri = Uri.parse(tokenUrl);
//        var tokenResult = await _post(
//          context: context,
//          url: uri.toString(),
//          needToken: true,
//          token: token,
//          options: await _getDioOptionsWithRefreshToken(),
//        );
////
//        AccountHelper.renewToken(tokenResult);
////
//        print("on [$tag], $processName from ($url) produces after refresh token\n$result}");
////
//        return result.data;
//      }
//    }
//  }

//    if (error.response.data.runtimeType == String) {
//    Toast.showToast(context, "Error:Type error salah\n${error.response.data}");
//    } else {
//    Toast.showToast(context, "Error:\n${error.response.data}");
//    }
//  }
//}

  Future _post(
      {BuildContext context,
        String url,
        var param,
        int lastCounter,
        int refreshCounter,
        CancelToken token,
        bool needToken = false,
        bool withTimeout = false,
        Options options}) async {
    int counter = lastCounter ?? 0;
    refreshCounter ??= 0;

    Dio dio = Dio();

    token ??= new CancelToken();

    options ??= withTimeout
        ? await _getDioOptionsWithTimeout(needToken: needToken)
        : await _getDioOptions(needToken: needToken);

    var result = await dio
        .post<dynamic>(url, data: param, options: options, cancelToken: token)
        .catchError((error) {
      logger.d("options ${options.headers}");
      logger.d("param $param");
      logger.d("error lagi $error");
      return _handleError(context, counter, refreshCounter, error, url, token, needToken,
          RequestType.post, withTimeout,
          param: param);
    });

    return result;
  }

  Future _put(
      {BuildContext context,
        String url,
        var param,
        int lastCounter,
        int refreshCounter,
        CancelToken token,
        bool needToken = false,
        bool withTimeout = false}) async {
    int counter = lastCounter ?? 0;
    refreshCounter ??= 0;

    Dio dio = Dio();

    token ??= new CancelToken();

    var options = withTimeout
        ? await _getDioOptionsWithTimeout(needToken: needToken)
        : await _getDioOptions(needToken: needToken);

    var result = await dio
        .put<dynamic>(url, data: param, options: options, cancelToken: token)
        .catchError((error) {
      logger.d("error lagi $error");
      return _handleError(context, counter, refreshCounter, error, url, token, needToken,
          RequestType.put, withTimeout,
          param: param);
    });

    return result;
  }

  Future _get(
      {BuildContext context,
        String url,
        int lastCounter,
        int refreshCounter,
        CancelToken token,
        bool needToken = false,
        bool withTimeout = true}) async {
    int counter = lastCounter ?? 0;
    refreshCounter ??= 0;

    Dio dio = Dio();

    token ??= new CancelToken();

    var options = withTimeout
        ? await _getDioOptionsWithTimeout(needToken: needToken)
        : await _getDioOptions(needToken: needToken);

    var result =
    await dio.get<dynamic>(url, options: options, cancelToken: token).catchError((error) async {
      DioError e = error.runtimeType == DioError ? error :  DioError(error: error);
      return _handleError(
        context,
        counter,
        refreshCounter,
        e,
        url,
        token,
        needToken,
        RequestType.get,
        withTimeout,
      );
    });

    return result;
  }

  Future _delete(
      {BuildContext context,
        String url,
        int lastCounter,
        int refreshCounter,
        CancelToken token,
        bool needToken = false,
        bool withTimeout = true}) async {
    int counter = lastCounter ?? 0;
    refreshCounter ??= 0;

    Dio dio = Dio();

    token ??= new CancelToken();

    var options = withTimeout
        ? await _getDioOptionsWithTimeout(needToken: needToken)
        : await _getDioOptions(needToken: needToken);

    var result = await dio
        .delete<dynamic>(url, options: options, cancelToken: token)
        .catchError((error) async {
      return _handleError(
        context,
        counter,
        refreshCounter,
        error,
        url,
        token,
        needToken,
        RequestType.delete,
        withTimeout,
      );
    });

    return result;
  }

  Future _process(
      {BuildContext context,
        String url,
        var param,
        int lastCounter,
        int refreshCounter,
        CancelToken token,
        bool needToken = false,
        bool withTimeout = false,
        RequestType requestType,
        String processName}) async {
    assert(requestType != null);
    PertaminaDict dict = PertaminaDict.of(context);

    var result;

    if (requestType == RequestType.post) {
      result = await _post(
        context: context,
        url: url,
        param: param,
        lastCounter: lastCounter,
        refreshCounter: refreshCounter,
        token: token,
        needToken: needToken,
        withTimeout: withTimeout,
      );
    } else if (requestType == RequestType.put) {
      result = await _put(
        context: context,
        url: url,
        param: param,
        lastCounter: lastCounter,
        refreshCounter: refreshCounter,
        token: token,
        needToken: needToken,
        withTimeout: withTimeout,
      );
    } else if (requestType == RequestType.get) {
      result = await _get(
        context: context,
        url: url,
        lastCounter: lastCounter,
        refreshCounter: refreshCounter,
        token: token,
        needToken: needToken,
        withTimeout: withTimeout,
      );
    } else if (requestType == RequestType.delete) {
      result = await _delete(
        context: context,
        url: url,
        lastCounter: lastCounter,
        refreshCounter: refreshCounter,
        token: token,
        needToken: needToken,
        withTimeout: withTimeout,
      );
    }

    logger.d("$processName from ($url) produces\n$result");

    if (result == null) return null;

    if (result.data is Map) {
      if (result.data["status"] == "0") {
        if (result.data["error_codes"][0] == "TOKEN_NOT_FOUND") {
          logger.d("$processName Token not found!");

          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text(dict.getString("information")),
                content: new Text(dict.getString("logged_in_on_another_device")),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text(dict.getString("close")),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ).then((_) async {
//            await AccountHelper.signOut();
//            Routing.pushAndRemoveUntil(context, LoginPage(), (_) => false);
          });

          return null;
        } else if (result.data["error_codes"][0] == "TOKEN_EXPIRED") {
          String tokenUrl = baseUrl + "/user/login/refresh";
          var uri = Uri.parse(tokenUrl);
          var tokenResult = await _post(
            context: context,
            url: uri.toString(),
            needToken: true,
            token: token,
            options: await _getDioOptionsWithRefreshToken(),
          );

//          AccountHelper.renewToken(tokenResult);

          var result;

          if (requestType == RequestType.post) {
            result = await _post(
              context: context,
              url: url,
              param: param,
              lastCounter: lastCounter,
              refreshCounter: refreshCounter,
              token: token,
              needToken: needToken,
              withTimeout: withTimeout,
            );
          } else if (requestType == RequestType.put) {
            result = await _put(
              context: context,
              url: url,
              param: param,
              lastCounter: lastCounter,
              refreshCounter: refreshCounter,
              token: token,
              needToken: needToken,
              withTimeout: withTimeout,
            );
          } else if (requestType == RequestType.get) {
            result = await _get(
              context: context,
              url: url,
              lastCounter: lastCounter,
              refreshCounter: refreshCounter,
              token: token,
              needToken: needToken,
              withTimeout: withTimeout,
            );
          } else if (requestType == RequestType.delete) {
            result = await _delete(
              context: context,
              url: url,
              lastCounter: lastCounter,
              refreshCounter: refreshCounter,
              token: token,
              needToken: needToken,
              withTimeout: withTimeout,
            );
          }

          logger.d("on [$tag], $processName from ($url) produces after refresh token\n$result}");

          return result.data;
        }
      }
    }

    return result.data;
  }
}
