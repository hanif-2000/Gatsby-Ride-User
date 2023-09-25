import 'dart:developer';
import 'dart:io';

import 'package:GetsbyRideshare/core/domain/usecases/get_currency.dart';
import 'package:GetsbyRideshare/core/presentation/providers/currency_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lctn;
import 'package:permission_handler/permission_handler.dart';

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
    // getLocationPermission();
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

// Using permission_handler for both platforms
  void getLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      var status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        var status = await Permission.locationAlways.request();
        if (status.isGranted) {
          //Do some stuff
        } else {
          //Do another stuff
        }
      } else {
        //The user deny the permission
      }
      if (status.isPermanentlyDenied) {
        //When the user previously rejected the permission and select never ask again
        //Open the screen of settings

        var check = await Permission.locationWhenInUse.request();
        log("cehck -->> ${check.isGranted}");

        if (check.isGranted) {
          log("granted success");
          getCurrentLocation();
        }
        // bool res = await openAppSettings();
      }
    } else {
      //In use is available, check the always in use
      var status = await Permission.locationAlways.status;
      if (!status.isGranted) {
        var status = await Permission.locationAlways.request();
        if (status.isGranted) {
          //Do some stuff
        } else {
          //Do another stuff
        }
      } else {
        //previously available, do some stuff or nothing
      }
    }

    // print('\n\nLocationRepository.getLocationPermission() started\n\n');
    // late String permission;
    // permission = await Permission.locationWhenInUse.status.then((value) {
    //   print(
    //       '\n\n LocationRepository.getLocationPermission Permission.locationWhenInUse.status is ${value.name}');

    //   // permission = await Permission.location.status.then((value) {
    //   //   print(
    //   //       '\n\n LocationRepository.getLocationPermission Permission.location.status is ${value.name}');
    //   switch (value) {
    //     case PermissionStatus.denied:
    //       return 'denied';
    //     case PermissionStatus.permanentlyDenied:
    //       return 'deniedForever';
    //     case PermissionStatus.limited:
    //       return 'limited';
    //     case PermissionStatus.granted:
    //       return 'granted';
    //     case PermissionStatus.restricted:
    //       return 'restricted';
    //   }
    //   return permission;
    // });
    // return permission;
  }

  Future<String> requestLocationPermission() async {
    print('LocationRepository.requestLocationPermission started');
    late String permission;
    // general location doesn't open the popup
    // var status = await Permission.location.status;
    // print('Permission.location.status is $status');
    var status = await Permission.locationWhenInUse.status;
    print('Permission.locationWhenInUse.status is $status');

    /// NOT Granted
    if (!status.isGranted) {
      // var status = await Permission.location.request();
      // print('Permission.location.request() status is $status');
      var status = await Permission.locationWhenInUse.request();
      print('Permission.locationWhenInUse.request() status is $status');
      if (status.isGranted) {
        permission = 'granted';
      } else {
        permission = 'denied';
      }
    }

    /// Granted
    else {
      permission = 'granted';
    }
    return permission;
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

        log("order id is=====>>>>" + session.orderId.toString());

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
