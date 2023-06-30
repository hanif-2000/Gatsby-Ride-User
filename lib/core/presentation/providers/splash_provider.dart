import 'dart:developer';
import 'dart:io';

import 'package:appkey_taxiapp_user/core/domain/usecases/get_currency.dart';
import 'package:appkey_taxiapp_user/core/presentation/providers/currency_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lctn;

import '../../utility/helper.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';

class SplashProvider with ChangeNotifier {
  final GetCurrency getCurrency;

  SplashProvider({required this.getCurrency});

  final lctn.Location locationService = lctn.Location();

  String deviceType = '';

  var session = locator<Session>();

  // Fetch all data from session
  getSessionData() {
    log("Is Login : " + session.isLoggedIn.toString());
    log("Order Id : " + session.orderId.toString());
    log("Chat Token : " + session.chatToken.toString());
    log("Session Token : " + session.sessionToken.toString());
    log("Session Fcm Token : " + session.sessionFcmToken.toString());
    log("Currency: " + session.currency.toString());
    log("Driver ID : " + session.driverId.toString());
    log("User ID : " + session.userId.toString());
    log("Order Status : " + session.orderStatus.toString());
    log("Current Lat : " + session.currentLat.toString());
    log("Current Long : " + session.currentLong.toString());
  }

  Stream<CurrencyState> fetchCurrency() async* {
    getCurrentLocation();

    getDeviceType();

    // enter loading state
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

    getSessionData();
  }

  //Get Current Location
  getCurrentLocation() async {
    final session = locator<Session>();
    log("get current location =-===>");

    try {
      bool serviceStatus = await locationService.serviceEnabled();
      if (serviceStatus) {
        lctn.LocationData locationData = await locationService.getLocation();
        logMe("locationData");
        logMe(locationData);
        var initialLatLong =
            LatLng(locationData.latitude!, locationData.longitude!);

        log("Initial lat long:---->>> $initialLatLong");

        session.setCurrentLat = locationData.latitude.toString();
        session.setCurrentLong = locationData.longitude.toString();

        log("Driver id is=====>>>>" + session.orderId.toString());

        // getAddressFromLatLng();
        //onlocation change
        locationService.onLocationChanged.listen((event) {});
      } else {
        try {
          bool serviceStatusResult = await locationService.requestService();
          logMe("Service status activated after request: $serviceStatusResult");
          if (serviceStatusResult) {
            getCurrentLocation();
          }
        } catch (e) {
          logMe(e.toString());
        }
      }
    } on PlatformException catch (e) {
      if (e.toString() == 'PERMISSION_DENIED') {
        logMe(e.toString());
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        logMe(e.message);
      }
    }
  }

  //Get Device Type
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
