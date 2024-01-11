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

class SplashProvider with ChangeNotifier {
  final GetCurrency getCurrency;

  SplashProvider({required this.getCurrency});

  // final Location locationService = lctn.Location();

  String deviceType = '';

  var session = locator<Session>();

  // Location location = Location();
  final Location _location = Location();

  // Fetch all data from session
  getSessionData() {
    log("Is Login : " + session.isLoggedIn.toString());
    log("Order Id : " + session.orderId.toString());
    log("Chat Token : " + session.chatToken.toString());
    log("Session Token : " + session.sessionToken.toString());
    log("Session Fcm Token : " + session.sessionFcmToken.toString());

    if (session.sessionFcmToken == '') {
      FirebaseMessaging _firebaseMessaging =
          FirebaseMessaging.instance; // Change here
      _firebaseMessaging.getToken().then((token) {
        session.setFcmToken = token!;
        notifyListeners();
        print("fcm token token is $token");
      });
    }
    log("Session Fcm Token : " + session.sessionFcmToken.toString());
    log("Currency: " + session.currency.toString());
    log("Driver ID : " + session.driverId.toString());
    log("User ID : " + session.userId.toString());
    log("Order Status : " + session.orderStatus.toString());
    log("Current Lat : " + session.currentLat.toString());
    log("Current Long : " + session.currentLong.toString());
  }

  Stream<CurrencyState> fetchCurrency() async* {
   await checkLocationAndPermission();
    // getCurrentLocation();

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

// // Using permission_handler for both platforms
//   void getLocationPermission() async {
//     var status = await Permission.locationWhenInUse.status;
//     if (!status.isGranted) {
//       var status = await Permission.locationWhenInUse.request();
//       if (status.isGranted) {
//         var status = await Permission.locationAlways.request();
//         if (status.isGranted) {
//           //Do some stuff
//         } else {
//           //Do another stuff
//         }
//       } else {
//         //The user deny the permission
//       }
//       if (status.isPermanentlyDenied) {
//         //When the user previously rejected the permission and select never ask again
//         //Open the screen of settings

//         var check = await Permission.locationWhenInUse.request();
//         log("cehck -->> ${check.isGranted}");

//         if (check.isGranted) {
//           log("granted success");
//           getCurrentLocation();
//         }
//         // bool res = await openAppSettings();
//       }
//     } else {
//       //In use is available, check the always in use
//       var status = await Permission.locationAlways.status;
//       if (!status.isGranted) {
//         var status = await Permission.locationAlways.request();
//         if (status.isGranted) {
//           //Do some stuff
//         } else {
//           //Do another stuff
//         }
//       } else {
//         //previously available, do some stuff or nothing
//       }
//     }

//     // print('\n\nLocationRepository.getLocationPermission() started\n\n');
//     // late String permission;
//     // permission = await Permission.locationWhenInUse.status.then((value) {
//     //   print(
//     //       '\n\n LocationRepository.getLocationPermission Permission.locationWhenInUse.status is ${value.name}');

//     //   // permission = await Permission.location.status.then((value) {
//     //   //   print(
//     //   //       '\n\n LocationRepository.getLocationPermission Permission.location.status is ${value.name}');
//     //   switch (value) {
//     //     case PermissionStatus.denied:
//     //       return 'denied';
//     //     case PermissionStatus.permanentlyDenied:
//     //       return 'deniedForever';
//     //     case PermissionStatus.limited:
//     //       return 'limited';
//     //     case PermissionStatus.granted:
//     //       return 'granted';
//     //     case PermissionStatus.restricted:
//     //       return 'restricted';
//     //   }
//     //   return permission;
//     // });
//     // return permission;
//   }

  // Future<void> requestNotificationPermissions() async {
  //   final PermissionStatus status = await Permission.notification.request();

  //   log("notification permission status is:-->> ${status}");
  //   if (status.isGranted) {
  //     // Notification permissions granted0
  //   } else if (status.isDenied) {
  //     final PermissionStatus status1 = await Permission.notification.request();

  //     // Notification permissions denied
  //   } else if (status.isPermanentlyDenied) {
  //     // Notification permissions permanently denied, open app settings
  //     await openAppSettings();
  //   }
  // }

  // Future<String> requestLocationPermission() async {
  //   print('LocationRepository.requestLocationPermission started');
  //   late String permission;
  //   // general location doesn't open the popup
  //   // var status = await Permission.location.status;
  //   // print('Permission.location.status is $status');
  //   var status = await Permission.locationWhenInUse.status;
  //   print('Permission.locationWhenInUse.status is $status');

  //   /// NOT Granted
  //   if (!status.isGranted) {
  //     // var status = await Permission.location.request();
  //     // print('Permission.location.request() status is $status');
  //     var status = await Permission.locationWhenInUse.request();
  //     print('Permission.locationWhenInUse.request() status is $status');
  //     if (status.isGranted) {
  //       permission = 'granted';
  //     } else {
  //       permission = 'denied';
  //     }
  //   }

  //   /// Granted
  //   else {
  //     permission = 'granted';
  //   }
  //   return permission;
  // }

  // //Get Current Location
  // getCurrentLocation() async {
  //   final session = locator<Session>();
  //   log("get current location =-===>");

  //   try {
  //     bool serviceStatus = await locationService.serviceEnabled();
  //     if (serviceStatus) {
  //       lctn.LocationData locationData = await locationService.getLocation();
  //       logMe("locationData");
  //       logMe(locationData);
  //       var initialLatLong =
  //           LatLng(locationData.latitude!, locationData.longitude!);

  //       log("Initial lat long:---->>> $initialLatLong");

  //       session.setCurrentLat = locationData.latitude.toString();
  //       session.setCurrentLong = locationData.longitude.toString();

  //       log("order id is=====>>>>" + session.orderId.toString());

  //       // getAddressFromLatLng();
  //       //onlocation change
  //       locationService.onLocationChanged.listen((event) {});
  //     } else {
  //       try {
  //         bool serviceStatusResult = await locationService.requestService();
  //         logMe("Service status activated after request: $serviceStatusResult");
  //         if (serviceStatusResult) {
  //           getCurrentLocation();
  //         }
  //       } catch (e) {
  //         logMe(e.toString());
  //       }
  //     }
  //   } on PlatformException catch (e) {
  //     if (e.toString() == 'PERMISSION_DENIED') {
  //       logMe(e.toString());
  //     } else if (e.code == 'SERVICE_STATUS_ERROR') {
  //       logMe(e.message);
  //     }
  //   }
  // }

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

  /// CHECK LOCATION AND PERMISSION
  Future<bool> checkLocationAndPermission() async {
    PermissionStatus permission;
    //Check location permission
    permission = await _location.hasPermission();
    if (permission == PermissionStatus.granted) {
      //If location permission is granted then return true
      return true;
    } else if (permission == PermissionStatus.denied) {
// If location permission is denied then ask for location permission again

      await Geolocator.requestPermission().whenComplete(() async {
// Again check the location permission

        permission = await _location.hasPermission();
      });
      if (permission == PermissionStatus.granted) {
        //if location is granted then return true
        return true;
      } else {
        //if location is denied then return false
        return false;
      }
    } else if (permission == PermissionStatus.deniedForever) {
      // if location permission is denied forever then return false
      return false;
    } else {
      return false;
    }
  }
}
