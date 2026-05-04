import 'dart:developer';
import 'dart:io';

import 'package:GetsbyRideshare/core/domain/usecases/get_currency.dart';
import 'package:GetsbyRideshare/core/presentation/providers/currency_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
// import 'package:location/location.dart' as lctn;

import '../../utility/injection.dart';
import '../../utility/session_helper.dart';

class SplashProvider extends ChangeNotifier{
  String deviceType = '';

  var session = locator<Session>();

  // Fetch all data from session
  getSessionData() {
    log("IsLogin ===========: " + session.isLoggedIn.toString());
    log("OrderId ===========: " + session.orderId.toString());
    log("ChatToken ===========: " + session.chatToken.toString());
    log("SessionToken ===========: " + session.sessionToken.toString());
    log("SessionFcmToken ===========: " + session.sessionFcmToken.toString());
    if (session.sessionFcmToken == '') {
      _getFcmToken().then((token) {
        if (token != null) {
          session.setFcmToken = token;
          notifyListeners();
          print("fcm token token is $token");
        }
      });
    }

  }

/*  Stream<CurrencyState> fetchCurrency() async* {
    yield CurrencyLoading();

    // getting data
    final result = await getCurrency();

    yield* result.fold(
      (failure) async* {
        // enter failure state
        yield CurrencyFailure(failure: failure);
      },
      (data) async* {
        final session = locator<Session>();
        session.setCurrency = data.data;
        yield CurrencyLoaded(data: data);
      },
    );

  }*/

  Future<String?> _getFcmToken() async {
    if (Platform.isIOS) {
      String? apnsToken;
      int retries = 0;
      while (apnsToken == null && retries < 5) {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 2));
          retries++;
        }
      }
      if (apnsToken == null) return null;
    }
    return await FirebaseMessaging.instance.getToken();
  }

  getDeviceType() {
    if (Platform.isAndroid) {
      deviceType = "android";
      session.setDeviceType = 'android';
    } else if (Platform.isIOS) {
      deviceType = "ios";
      session.setDeviceType = 'ios';
    }
    notifyListeners();
  }
}
