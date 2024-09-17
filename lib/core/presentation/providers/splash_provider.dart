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
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
      _firebaseMessaging.getToken().then((token) {
        session.setFcmToken = token!;
        notifyListeners();
        print("fcm token token is $token");
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
