import 'package:shared_preferences/shared_preferences.dart';

import '../static/strings.dart';

abstract class Session {
  set setLoggedIn(bool login);
  set setOrderId(String orderId);
  set setToken(String token);
  set setChatToken(int token);
  set setFcmToken(String fcmToken);
  set setCurrency(String currency);
  set setOrderStatus(int orderStatus);
  set setDriverId(String driverId);
  set setUserId(String userId);
  set setCurrentLat(String currentLat);
  set setCurrentLong(String currentLong);
  set setDeviceType(String device);
  set setEstimatedDistance(String distance);
  set setEstimatedTime(String time);

  set setOriginAddress(String originAddress);
  set setDestinationAddress(String destinationAddress);
  set setOriginLat(double originLat);
  set setOriginLong(double originLong);
  set setDestinationLat(double destinationLat);
  set setDestinationLong(double destinationLong);

  bool get isLoggedIn;
  String get orderId;
  int get chatToken;

  String get estimatedDistance;
  String get estimatedTime;

  String get sessionToken;
  String get sessionFcmToken;
  String get currency;
  String get driverId;
  String get userId;
  int get orderStatus;
  String get currentLat;
  String get currentLong;
  String get device;

  String get originAddress;
  String get destinationAddress;
  double get originLat;
  double get originLong;

  double get destinationLat;
  double get destinationLong;

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
  set setEstimatedDistance(String distance) {
    pref.setString(ESTIMATED_DISTANCE, distance);
  }

  @override
  set setEstimatedTime(String time) {
    pref.setString(ESTIMATED_TIME, time);
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
  set setChatToken(int token) {
    pref.setInt(CHAT_TOKEN, token);
  }

  @override
  set setDeviceType(String device) {
    pref.setString(DEVICE, device);
  }

  @override
  set setOriginAddress(String originAddress) {
    pref.setString(ORIGIN_ADDRESS, originAddress);
  }

  @override
  set setDestinationAddress(String destinationAddress) {
    pref.setString(DESTINATION_ADDRESS, destinationAddress);
  }

  @override
  set setOriginLat(double originLat) {
    pref.setDouble(ORIGIN_LAT, originLat);
  }

  @override
  set setOriginLong(double originLong) {
    pref.setDouble(ORIGIN_LONG, originLong);
  }

  set setDestinationLat(double destinationLat) {
    pref.setDouble(DESTINATION_LAT, destinationLat);
  }

  set setDestinationLong(double destinationLong) {
    pref.setDouble(DESTINATION_LONG, destinationLong);
  }

  @override
  bool get isLoggedIn => pref.getBool(IS_LOGGED_IN) ?? false;

  @override
  int get chatToken => pref.getInt(CHAT_TOKEN) ?? 0;

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
    await pref.remove(ESTIMATED_DISTANCE);
    await pref.remove(ESTIMATED_TIME);
  }

  @override
  String get device => pref.getString(DEVICE) ?? '';

  @override
  String get destinationAddress => pref.getString(DESTINATION_ADDRESS) ?? '';

  @override
  double get destinationLat => pref.getDouble(DESTINATION_LAT) ?? 0.0;

  @override
  double get destinationLong => pref.getDouble(DESTINATION_LONG) ?? 0.0;

  @override
  String get originAddress => pref.getString(ORIGIN_ADDRESS) ?? '';

  @override
  double get originLat => pref.getDouble(ORIGIN_LAT) ?? 0.0;

  @override
  double get originLong => pref.getDouble(ORIGIN_LAT) ?? 0.0;

  @override
  String get estimatedDistance => pref.getString(ESTIMATED_DISTANCE) ?? '';

  @override
  String get estimatedTime => pref.getString(ESTIMATED_TIME) ?? '';
}
