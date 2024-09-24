import 'package:shared_preferences/shared_preferences.dart';

import '../static/strings.dart';

abstract class Session {
/** SETTER---------------------------------------------------------------------- */
  set setLoggedIn(bool login);
  set setIsRunningOrder(bool isRunningOrder);
  set setIsPaymentDone(bool paymentDone);
  set setIsRatingGiven(bool ratingGiven);
  set setSearchingTime(int searchingTime);
  set setBookingTime(String bookingTime);

  set setOrderId(String orderId);
  set setToken(String token);
  set setChatToken(int token);
  set setFcmToken(String fcmToken);
  set setOldFcmToken(String fcmToken);

  set setCurrency(String currency);
  set setOrderStatus(int orderStatus);
  set setDriverId(String driverId);
  set setUserId(String userId);
  set setCurrentLat(double currentLat);
  set setCurrentLong(double currentLong);
  set setDeviceType(String device);
  set setEstimatedDistance(String distance);
  set setEstimatedTime(String time);
  set setDriverLatLong(String driverLatLng);

  /** DRIVER DETAILS ADD Start */

  set setDriverImg(String img);
  set setDriverPhn(String phn);
  set setDriverName(String name);
  set setDriverRating(String rating);
  set setVehicleName(String vehicleName);
  set setVehicleModel(String vehicleModel);
  set setVehiclePlate(String vehiclePlate);
  set setRideTotal(String total);
  set setOrderReceipt(String receipt);

  /** DRIVER DETAILS END */

  set setOriginAddress(String originAddress);
  set setDestinationAddress(String destinationAddress);
  set setOriginLat(double originLat);
  set setOriginLong(double originLong);
  set setDestinationLat(double destinationLat);
  set setDestinationLong(double destinationLong);
  set setOrderDetails(orderDetails);
  set setDriverDetails(DriverDetails);

/** GETTER---------------------------------------------------------------------- GETTER */

  bool get isLoggedIn;
  bool get isRunningOrder;
  bool get isRatingGiven;
  bool get isPaymentDone;

  String get orderId;
  int get chatToken;

  String get estimatedDistance;
  String get estimatedTime;
  int get searchingTime;
  String get bookingTime;

  String get sessionToken;
  String get sessionFcmToken;
  String get sessionOldFcmToken;

  String get currency;
  String get driverId;
  String get userId;
  int get orderStatus;
  double get currentLat;
  double get currentLong;
  String get device;
  String get driverLatLng;

  /** GET DRIVER DETAILS Start*/

  String get driverImg;
  String get driverName;
  String get driverRating;
  String get driverPhn;
  String get vehicleName;
  String get vehicleModel;
  String get vehiclePlate;
  String get rideTotal;

  /** GET DRIVER DETAILS  END*/

  String get originAddress;
  String get destinationAddress;
  double get originLat;
  double get originLong;

  double get destinationLat;
  double get destinationLong;

  /// * GET ORDER DETAILS
  String get orderDetails;

  /// * GET Driver DETAILS
  String get DriverDetails;
  String get orderReceipt;

  Future<void> clearSession();
  Future<void> clearOrderSession();
}

/** SESSION HELPER---------------------------------------------------------------------- SESSION HELPER */

class SessionHelper implements Session {
  final SharedPreferences pref;

  SessionHelper({required this.pref});
/** SESSION SETTER----------------------------------------------------------------------SESSION SETTER */

  /// * save order details--------*/

  @override
  set setOrderDetails(sessionOrder) {
    pref.setString(SESSION_ORDER_DETAILS, sessionOrder);
  }

  @override
  set setBookingTime(bookingTime) {
    pref.setString(BOOKING_TIME, bookingTime);
  }

  ///******** Save Driver DETAILS-------  */
  ///

  @override
  set setDriverDetails(sessionDriverDetails) {
    pref.setString(SESSION_Driver_DETAILS, sessionDriverDetails);
  }

  @override
  set setLoggedIn(bool login) {
    pref.setBool(IS_LOGGED_IN, login);
  }

/*** RUNNING ORDER CHECK */
  @override
  set setIsRunningOrder(bool isRunningOrder) {
    pref.setBool(IS_RUNNING_ORDER, isRunningOrder);
  }

  @override
  set setToken(String token) {
    pref.setString(SESSION_TOKEN, token);
  }
/** Driver lat liogn */

  @override
  set setDriverLatLong(String driverLatLng) {
    pref.setString(DRIVER_LATLONG, driverLatLng);
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

/** DRIVER DETAILS START */

//NAME
  @override
  set setDriverName(String driverName) {
    pref.setString(DRIVER_NAME, driverName);
  }

//IMAGE
  @override
  set setDriverImg(String driverImg) {
    pref.setString(DRIVER_IMG, driverImg);
  }

//PHONE
  @override
  set setDriverPhn(String driverPhn) {
    pref.setString(DRIVER_PHN, driverPhn);
  }

//RATING
  @override
  set setDriverRating(String driverRating) {
    pref.setString(DRIVER_RATING, driverRating);
  }

//VEHCIEL NAME
  @override
  set setVehicleName(String vehicleName) {
    pref.setString(VEHICLE_NAME, vehicleName);
  }

//vehice; model
  @override
  set setVehicleModel(String vehicleModel) {
    pref.setString(VEHICLE_MODEL, vehicleModel);
  }

//plate number
  @override
  set setVehiclePlate(String vehiclePlate) {
    pref.setString(VEHICL_PLATE, vehiclePlate);
  }

//ride total
  @override
  set setRideTotal(String rideTotal) {
    pref.setString(RIDE_TOTAL, rideTotal);
  }

/** DRIVER DETAILS END */

  @override
  set setOrderStatus(int orderStatus) {
    pref.setInt(ORDER_STATUS, orderStatus);
  }

  @override
  set setFcmToken(String fcmToken) {
    pref.setString(FCM_TOKEN, fcmToken);
  }

  @override
  set setOldFcmToken(String fcmOldToken) {
    pref.setString(FCM_OLD_TOKEN, fcmOldToken);
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
  set setCurrentLat(double currentLat) {
    pref.setDouble(CURRENT_LAT, currentLat);
  }

  @override
  set setCurrentLong(double currentLong) {
    pref.setDouble(CURRENT_LONG, currentLong);
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
  set setOrderReceipt(String receipt) {
    pref.setString(ORDER_RECEIPT, receipt);
  }

  @override
  set setIsPaymentDone(bool paymentDone) {
    pref.setBool(PAYMENT_DONE, paymentDone);
  }

  @override
  set setIsRatingGiven(bool ratingGiven) {
    pref.setBool(RATING_GIVEN, ratingGiven);
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

  set setSearchingTime(int searchingTime) {
    pref.setInt(SEARCHING_TIME, searchingTime);
  }

/** SESSION GETTER----------------------------------------------------------------------SESSION GETTER */

  @override
  bool get isLoggedIn => pref.getBool(IS_LOGGED_IN) ?? false;

  @override
  bool get isRunningOrder => pref.getBool(IS_RUNNING_ORDER) ?? false;

  @override
  bool get isRatingGiven => pref.getBool(RATING_GIVEN) ?? true;
  @override
  bool get isPaymentDone => pref.getBool(PAYMENT_DONE) ?? true;

  @override
  int get chatToken => pref.getInt(CHAT_TOKEN) ?? 0;

  @override
  int get searchingTime => pref.getInt(SEARCHING_TIME) ?? 30;

  @override
  String get sessionToken => pref.getString(SESSION_TOKEN) ?? '';

  @override
  String get bookingTime => pref.getString(BOOKING_TIME) ?? '';

/** DRIVER LAT LONG */
  @override
  String get driverLatLong => pref.getString(DRIVER_LATLONG) ?? '0,0';

  /// **** order dewtails

  @override
  String get orderDetails =>
      pref.getString(SESSION_ORDER_DETAILS) ??
      'session order details are null ';

  /// * Driver details

  @override
  String get DriverDetails =>
      pref.getString(SESSION_Driver_DETAILS) ??
      'session Driver details are null';

  @override
  String get userId => pref.getString(USER_ID) ?? '';

  @override
  String get sessionFcmToken => pref.getString(FCM_TOKEN) ?? '';

  @override
  String get sessionOldFcmToken => pref.getString(FCM_OLD_TOKEN) ?? '';

  @override
  String get driverId => pref.getString(DRIVER_ID) ?? '';

  @override
  int get orderStatus => pref.getInt(ORDER_STATUS) ?? 100;

  @override
  String get currency => pref.getString(CURRENCY) ?? '';

  @override
  String get orderId => pref.getString(ORDER_ID) ?? '';

  //**drive details start */

  @override
  String get driverName => pref.getString(DRIVER_NAME) ?? '';
  @override
  String get driverImg => pref.getString(DRIVER_IMG) ?? '';
  @override
  String get driverRating => pref.getString(DRIVER_RATING) ?? '';
  @override
  String get driverPhn => pref.getString(DRIVER_PHN) ?? '';
  @override
  String get vehicleName => pref.getString(VEHICLE_NAME) ?? '';
  @override
  String get vehicleModel => pref.getString(VEHICLE_MODEL) ?? '';
  @override
  String get vehiclePlate => pref.getString(VEHICL_PLATE) ?? '';
  @override
  String get rideTotal => pref.getString(RIDE_TOTAL) ?? '';

  //driver details end

  @override
  double get currentLat => pref.getDouble(CURRENT_LAT) ?? 0.0;

  @override
  double get currentLong => pref.getDouble(CURRENT_LONG) ?? 0.0;

  @override
  Future<void> clearSession() async {
    setOldFcmToken = pref.getString(FCM_TOKEN)!;

    await pref.clear();
    setFcmToken = sessionFcmToken;
  }

  @override
  Future<void> clearOrderSession() async {
    // await pref.remove(ORDER_ID);
    // await pref.remove(ORDER_STATUS);
    // await pref.remove(DRIVER_ID);
    await pref.remove(ESTIMATED_DISTANCE);
    await pref.remove(ESTIMATED_TIME);
    await pref.remove(SESSION_Driver_DETAILS);
    await pref.remove(SESSION_ORDER_DETAILS);
    await pref.remove(DRIVER_LATLONG);
    // await pref.remove(DRIVER_ID);
    await pref.remove(DRIVER_IMG);
    await pref.remove(DRIVER_NAME);
    // await pref.remove(DRIVER_ID);
    await pref.remove(ORIGIN_LAT);
    await pref.remove(ORIGIN_LONG);
    await pref.remove(ORIGIN_ADDRESS);
    await pref.remove(DESTINATION_ADDRESS);
    await pref.remove(RATING_GIVEN);
    await pref.remove(PAYMENT_DONE);
  }

  // @override
  // Future<void> clearOrderSessionNew() async {
  //   // await pref.remove(ORDER_ID);
  //   // await pref.remove(ORDER_STATUS);
  //   // await pref.remove(DRIVER_ID);
  //   await pref.remove(ESTIMATED_DISTANCE);
  //   await pref.remove(ESTIMATED_TIME);
  //   await pref.remove(SESSION_Driver_DETAILS);
  //   await pref.remove(SESSION_ORDER_DETAILS);
  //   await pref.remove(DRIVER_LATLONG);
  //   // await pref.remove(DRIVER_ID);
  //   await pref.remove(DRIVER_IMG);
  //   await pref.remove(DRIVER_NAME);
  //   // await pref.remove(DRIVER_ID);
  //   await pref.remove(ORIGIN_LAT);
  //   await pref.remove(ORIGIN_LONG);
  //   await pref.remove(ORIGIN_ADDRESS);
  //   await pref.remove(DESTINATION_ADDRESS);
  //   await pref.remove(RATING_GIVEN);
  //   await pref.remove(PAYMENT_DONE);
  //   await pref.remove(DESTINATION_ADDRESS);
  // }

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
  double get originLong => pref.getDouble(ORIGIN_LONG) ?? 0.0;

  @override
  String get estimatedDistance => pref.getString(ESTIMATED_DISTANCE) ?? '';

  @override
  String get estimatedTime => pref.getString(ESTIMATED_TIME) ?? '';

  @override
  String get driverLatLng => pref.getString(DRIVER_LATLONG) ?? '0,0';

  @override
  String get orderReceipt =>
      pref.getString(ORDER_RECEIPT) ?? "No order receipt";
}
