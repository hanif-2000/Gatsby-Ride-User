import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../features/history/data/models/history_response_model.dart'
    as history;
import '../static/dimens.dart';
import '../static/order_status.dart';
import 'app_settings.dart';
import 'injection.dart';
import 'session_helper.dart';

logMe(Object? obj) {
  /* 
    use this for print something, its run only on debug mode.
  */
  if (kDebugMode) {
    print(obj);
  }
}

// spacing
Widget smallVerticalSpacing() => const SizedBox(height: sizeSmall);
Widget smallHorizontalSpacing() => const SizedBox(width: sizeSmall);
Widget mediumVerticalSpacing() => const SizedBox(height: sizeMedium);
Widget mediumHorizontalSpacing() => const SizedBox(width: sizeMedium);
Widget largeVerticalSpacing() => const SizedBox(height: sizeLarge);
Widget largeHorizontalSpacing() => const SizedBox(width: sizeLarge);
Widget superLargeVerticalSpacing() => const SizedBox(height: sizeExtraLarge);

//Locale Language
late AppLocalizations appLoc;

//Route
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

Future<bool> checkPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  return true;
}

String mergeAddress(String placeName, String address) {
  String result;
  result = '$placeName, $address';
  return result;
}

String mergeTypeTaxi(history.CategoryClass category) {
  String result;
  String categoryName = category.category!;
  String seat = category.seat.toString();
  result = "$categoryName ($seat ${appLoc.people})";
  return result;
}

String mergePhotoUrl(String photoUrl) {
  String result;
  if (photoUrl == '') {
    result = '';
  } else {
    result = '$BASE_URL_PHOTO/$photoUrl';
  }

  return result;
}

String mergeDistanceTxt(String distance) {
  String result;
  result = '$distance km';
  return result;
}

String mergePriceTxt(String price) {
  final session = locator<Session>();
  String currency = session.currency;
  String result;
  result = '$currency$price ';

  return result;
}

Future<double> getDistance(
    LatLng originLatLng, LatLng destinationLatLng) async {
  return Geolocator.distanceBetween(
      originLatLng.latitude,
      originLatLng.longitude,
      destinationLatLng.latitude,
      destinationLatLng.longitude);
}

showLoading() {
  SmartDialog.showLoading(
    animationType: SmartAnimationType.centerFade_otherSlide,
    backDismiss: false,
    builder: (context) => const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
  );
}

dismissLoading() {
  SmartDialog.dismiss();
}

void showToast({required String message, Color? color}) {
  Fluttertoast.showToast(
      gravity: ToastGravity.TOP,
      backgroundColor: color ?? Colors.black,
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 1);
}

Future<void> sessionLogOut() async {
  final session = locator<Session>();
  await session.clearSession();
}

LatLngBounds getBounds(List<Marker> markers) {
  var lngs = markers.map<double>((m) => m.position.longitude).toList();
  var lats = markers.map<double>((m) => m.position.latitude).toList();

  double topMost = lngs.reduce(max);
  double leftMost = lats.reduce(min);
  double rightMost = lats.reduce(max);
  double bottomMost = lngs.reduce(min);

  LatLngBounds bounds = LatLngBounds(
    northeast: LatLng(rightMost, topMost),
    southwest: LatLng(leftMost, bottomMost),
  );

  return bounds;
}

Future<void> sessionClearOrder() async {
  final session = locator<Session>();
  await session.clearOrderSession();
}

String getDateString(DateTime date) {
  var strDate = DateFormat.yMd(myLocale.languageCode).format(date);
  var strTime = DateFormat("hh:mm aa", myLocale.languageCode).format(date);
  return "$strDate $strTime";
}

String getPaymentMethod(history.HistoryOrder data) {
  String result;
  if (data.paymentMethod == "1") {
    result = appLoc.cash;
  } else {
    result = "Google Pay";
  }
  return result;
}

String getHistoryStatus(int statusHistory) {
  String strStatus = "";
  switch (statusHistory) {
    case Order.lookingDriver:
      strStatus = appLoc.pending;
      break;
    case Order.driverAccept:
      strStatus = appLoc.gotDriver;
      break;
    case Order.departureToCustomerplace:
      strStatus = appLoc.departToCustomerPlace;
      break;
    case Order.arriveAtCustomerPlace:
      strStatus = appLoc.arriveAtCustomerPlace;
      break;
    case Order.customerConfirmation:
      strStatus = appLoc.arriveAtCustomerPlace;
      break;
    case Order.departureToDestination:
      strStatus = appLoc.departToDestination;
      break;
    case Order.arriveAtDestination:
      strStatus = appLoc.arriveAtDestination;
      break;
    case Order.complete:
      strStatus = "Completed";
      break;
    case Order.cancel:
      strStatus = "Cancelled";
      break;
  }
  return strStatus;
}
