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
  static bool _isNavigatingToLogin = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logMe("on request called");
    // set default headers (skip content-type for FormData — Dio sets multipart boundary automatically)
    if (options.data is! FormData) {
      options.headers.addAll({"content-type": "application/json; charset=utf-8"});
    }
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
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    log("dio exception error message:  ${err.message}");
    log("dio exception error err:  ${err}");
    log("dio exception error error:  ${err.error}");
    log("dio exception error response:  ${err.response}");
    log("dio exception error type:  ${err.type}");

    if (err.type == DioExceptionType.connectionError) {
      showNoInternetDialog();
    }

    logMe("DION ERROR CALLED");
    final statusCode = err.response?.statusCode;

    print(
        "<-- ${err.message} ${(err.response?.requestOptions != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')}"
        'DioException');
    print("${err.response != null ? err.response!.data : 'Unknown Error'}"
        'DioException');

    if (err.type == DioExceptionType.connectionTimeout) {
      showToast(
          message:
              'Connection timeout. Please check your internet connection.');
    }

    // if (statusCode == HttpStatus.unauthorized) {
    //   final session = locator<Session>();
    //   session.setLoggedIn = false;
    // }
    log("--->>>>>> status coder is :${statusCode} --------*****00");
    if (statusCode == HttpStatus.unprocessableEntity) {
      dismissLoading();
      // Don't logout on 422 — it's a validation error (e.g. login/register form errors)
      // just propagate the error to the caller
      // final session = locator<Session>();
      // session.setLoggedIn = false;
    }
    if (statusCode == HttpStatus.unauthorized || statusCode == 401) {
      print("====unauthorized called==>>");
      dismissLoading();
      if (!_isNavigatingToLogin) {
        _isNavigatingToLogin = true;
        await sessionLogOut().then(
          (_) => Navigator.pushNamedAndRemoveUntil(
            locator<GlobalKey<NavigatorState>>().currentContext!,
            LoginPage.routeName,
            (route) => false,
          ),
        );
        _isNavigatingToLogin = false;
      }
    }

    if (statusCode == HttpStatus.forbidden) {}

    return super.onError(err, handler);
  }
}
