import 'dart:io';

import 'package:GetsbyRideshare/core/presentation/pages/splash_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

import '../utility/helper.dart';
import '../utility/injection.dart';
import '../utility/session_helper.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // set default headers
    options.headers.addAll({"content-type": "application/json; charset=utf-8"});
    options.headers.addAll({"Accept": "application/json"});

    //check param 'required_token'
    const requiredToken = 'required_token';
    if (options.headers.containsKey(requiredToken)) {
      // remove required_token from headers
      options.headers.remove(requiredToken);

      // add authorization token
      String token = '';

      token = locator<Session>().sessionToken;

      options.headers.addAll({
        "Authorization": "Bearer $token",
      });
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    // if (statusCode == HttpStatus.unauthorized) {
    //   final session = locator<Session>();
    //   session.setLoggedIn = false;
    // }

    if (statusCode == HttpStatus.unprocessableEntity) {
      dismissLoading();
      await sessionLogOut().then(
        (_) => Navigator.pushNamedAndRemoveUntil(
          locator<GlobalKey<NavigatorState>>().currentContext!,
          SplashPage.routeName,
          (route) => false,
        ),
      );
      // final session = locator<Session>();
      // session.setLoggedIn = false;
    }

    if (statusCode == HttpStatus.forbidden) {}

    return super.onError(err, handler);
  }
}
