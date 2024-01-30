import 'dart:developer';
import 'dart:io';

import 'package:GetsbyRideshare/features/login/presentation/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

import '../utility/helper.dart';
import '../utility/injection.dart';
import '../utility/session_helper.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logMe("on request called");
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
    logMe("DION ERROR CALLED");
    final statusCode = err.response?.statusCode;

    print(
        "<-- ${err.message} ${(err.response?.requestOptions != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')}"
        'DioException');
    print("${err.response != null ? err.response!.data : 'Unknown Error'}"
        'DioException');

    // if (statusCode == HttpStatus.unauthorized) {
    //   final session = locator<Session>();
    //   session.setLoggedIn = false;
    // }
    log("--->>>>>> status coder is :${statusCode} --------*****00");
    if (statusCode == HttpStatus.unprocessableEntity) {
      dismissLoading();

      await sessionLogOut().then(
        (_) => Navigator.pushNamedAndRemoveUntil(
          locator<GlobalKey<NavigatorState>>().currentContext!,
          LoginPage.routeName,
          (route) => false,
        ),
      );
      // final session = locator<Session>();
      // session.setLoggedIn = false;
    }
    if (statusCode == HttpStatus.notFound) {
      print("====not found called==>>");
      dismissLoading();
      await sessionLogOut().then(
        (_) => Navigator.pushNamedAndRemoveUntil(
          locator<GlobalKey<NavigatorState>>().currentContext!,
          LoginPage.routeName,
          (route) => false,
        ),
      );
      // final session = locator<Session>();
      // session.setLoggedIn = false;
    }
    if (statusCode == 404) {
      print("====not found called==>>");
      dismissLoading();
      await sessionLogOut().then(
        (_) => Navigator.pushNamedAndRemoveUntil(
          locator<GlobalKey<NavigatorState>>().currentContext!,
          LoginPage.routeName,
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
