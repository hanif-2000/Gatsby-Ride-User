import 'package:shared_preferences/shared_preferences.dart';

import '../static/strings.dart';

abstract class Session {
  set setLoggedIn(bool login);
  set setOrderId(String orderId);
  set setToken(String token);
  set setFcmToken(String fcmToken);
  set setCurrency(String currency);
  set setOrderStatus(int orderStatus);
  set setDriverId(String driverId);
  set setUserId(String userId);
  set setCurrentLat(String currentLat);
  set setCurrentLong(String currentLong);

  bool get isLoggedIn;
  String get orderId;
  String get sessionToken;
  String get sessionFcmToken;
  String get currency;
  String get driverId;
  String get userId;
  int get orderStatus;
  String get currentLat;
  String get currentLong;

  Future<void> clearSession();
  Future<void> clearOrderSession();
}

class SessionHelper implements Session {
  final SharedPreferences pref;

  SessionHelper({required this.pref});

  @override
  set setLoggedIn(bool login) {
    pref.setBool(IS_LOGGED_IN, login);
  }

  @override
  set setToken(String token) {
    pref.setString(SESSION_TOKEN, token);
  }

  @override
  set setUserId(String userId) {
    pref.setString(USER_ID, userId);
  }

  @override
  set setDriverId(String driverId) {
    pref.setString(DRIVER_ID, driverId);
  }

  @override
  set setOrderStatus(int orderStatus) {
    pref.setInt(ORDER_STATUS, orderStatus);
  }

  @override
  set setFcmToken(String fcmToken) {
    pref.setString(FCM_TOKEN, fcmToken);
  }

  @override
  set setCurrency(String currency) {
    pref.setString(CURRENCY, currency);
  }

  @override
  set setOrderId(String orderId) {
    pref.setString(ORDER_ID, orderId);
  }

  @override
  set setCurrentLat(String currentLat) {
    pref.setString(CURRENT_LAT, currentLat);
  }

  @override
  set setCurrentLong(String currentLong) {
    pref.setString(CURRENT_LONG, currentLong);
  }

  @override
  bool get isLoggedIn => pref.getBool(IS_LOGGED_IN) ?? false;

  @override
  String get sessionToken => pref.getString(SESSION_TOKEN) ?? '';

  @override
  String get userId => pref.getString(USER_ID) ?? '';

  @override
  String get sessionFcmToken => pref.getString(FCM_TOKEN) ?? '';

  @override
  String get driverId => pref.getString(DRIVER_ID) ?? '';

  @override
  int get orderStatus => pref.getInt(ORDER_STATUS) ?? 100;

  @override
  String get currency => pref.getString(CURRENCY) ?? '';

  @override
  String get orderId => pref.getString(ORDER_ID) ?? '';

  @override
  String get currentLat => pref.getString(CURRENT_LAT) ?? '';

  @override
  String get currentLong => pref.getString(CURRENT_LONG) ?? '';

  @override
  Future<void> clearSession() async {
    await pref.clear();
  }

  @override
  Future<void> clearOrderSession() async {
    await pref.remove(ORDER_ID);
    await pref.remove(ORDER_STATUS);
    await pref.remove(DRIVER_ID);
  }
}
