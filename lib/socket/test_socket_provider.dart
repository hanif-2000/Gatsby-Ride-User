import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:GetsbyRideshare/socket/modals/accept_response_model.dart';
import 'package:GetsbyRideshare/socket/modals/booking_response_model.dart';
import 'package:GetsbyRideshare/socket/modals/driver_updated_position_model.dart';
import 'package:GetsbyRideshare/socket/modals/new_receipt_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:ui' as ui;
import '../../core/domain/entities/order_data_detail.dart';
import '../../core/presentation/pages/home_page/home_page.dart';
import '../../core/presentation/providers/home_provider.dart';
import '../../core/static/assets.dart';
import '../../core/utility/direction_helper.dart';
import '../../core/utility/helper.dart';
import '../../features/order/data/models/chat_modal.dart';
import '../../features/order/data/models/detail_driver_response.dart';
import '../../features/order/data/models/detail_order_response_model.dart';
import '../../features/order/data/models/get_driver_details_response_model.dart';
import '../../features/order/data/models/submit_rating_response_modal.dart';
import '../../features/order/domain/entities/order_detail.dart';

import 'package:location/location.dart' as lctn;
import '../../core/utility/notification_service.dart';

class TestSocketProvider extends ChangeNotifier {
  IO.Socket? _socket;
  List<ChatModel> _chatMessagesList = [];
  BookingDataModel? bookingDataModel;
  AcceptResponseModel? acceptResponseModel;
  ReceiptResponseModel? receiptResponseModel;
  var session = locator<Session>();
  int currentOrderStatus = 0;
  DriverDetailResponseModel? driverDetailResponseModel;
  OrderDetailResponseModel? orderDetailResponseModel;
  bool isWithDriver = false;
  bool originIsFilled = false;
  int unreadMessageCount = 0;
  String destinationAddress = "Destination";
  bool isLoading = false;
  bool isConnected = false;
  bool isChatPageOpen = false;
  Map<String, dynamic>? _pendingRideRequest;

  // ✅ FIX 1: Duplicate listener rokne ke liye flag
  bool _isListening = false;

  // Tracks the highest status for which a local notification was shown.
  // Prevents duplicate banners when the socket replays a status event after
  // background → foreground transition (socket reconnects while syncStatusFromApi
  // hasn't completed yet, so isNewXxx guards are still true).
  int _lastNotifiedStatus = 0;

  List<ChatModel> get chatMessageList => _chatMessagesList;
  BitmapDescriptor? destinationMarker, initialMarker, driverMarker;
  String originAddress = 'Pickup Address';
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  LatLng? originLatLng, destinationLatLng;
  final chatController = TextEditingController();
  String orderId = '';
  double bearing = 0.0;

  LatLng? _previousDriverLatLng;
  Timer? _driverAnimTimer;

  double ratingGiven = 1;
  late GoogleMapController googleMapController;
  double zoom = 15;

  var dio = Dio();
  double lat = 0.0;
  double long = 0.0;

  String commentGiven = '';
  TextEditingController commentsEditingController = TextEditingController();
  DriverDetail? _driverDetail;

  DriverDetail? get driverDetail => _driverDetail;

  /** update order details model */

  updateOrderDetailsModel({required OrderDetailResponseModel data}) {
    orderDetailResponseModel = data;

    print("================>>>> ${orderDetailResponseModel?.toJson()}");
    if (orderDetailResponseModel?.data != null) {
      var data = orderDetailResponseModel?.data;
      final oriLatLng = LatLng(
        double.tryParse(data!.startCoordinate.split(",").first) ?? 0.0,
        double.tryParse(data.startCoordinate.split(",").last) ?? 0.0,
      );
      final destLatLng = LatLng(
        double.tryParse(data.endCoordinate.split(",").first) ?? 0.0,
        double.tryParse(data.endCoordinate.split(",").last) ?? 0.0,
      );
      // Only overwrite if we got valid non-zero coords — Accept response often
      // sends "0,0" for end_coordinate, which would clobber the correct
      // destination set in initState from the booking data.
      if (oriLatLng.latitude != 0.0 || oriLatLng.longitude != 0.0) {
        updateOriginAndDestinationLatLong(origin: oriLatLng, destination: destLatLng);
      }
    }
    notifyListeners();
  }

  updateZoom(CameraPosition val) {
    zoom = val.zoom;
    notifyListeners();
  }

  updateRatingComment({double? rating, String? comment}) {
    ratingGiven = rating!;
    commentGiven = comment!;
    notifyListeners();
  }

  updateBearing({val}) {
    bearing = val;
    notifyListeners();
  }

  double _driverLat = 0.0;
  double _driverLng = 0.0;

  final lctn.Location locationService = lctn.Location();
  StreamSubscription<lctn.LocationData>? _customerLocationSubscription;

  bool isOrderAccepted = false;
  DriverUpdatedPositionModel? driverUpdatedPositionModel;
  var _homeProvider = locator<HomeProvider>();

  updateIsOrderAccepted({required bool val}) {
    isOrderAccepted = val;
    notifyListeners();
  }

  late LatLng driverLatLng;

  updateDriverLatLng({required LatLng driverLtLng}) {
    driverLatLng = driverLtLng;
    notifyListeners();
  }

  Future<void> updateReceiptResponseModel(data, {bool addData = false}) async {
    receiptResponseModel = data;
    if (addData) {
      receiptResponseModel?.data = receiptResponseModel!.order;
    }
    notifyListeners();
  }

  updateIsWithDriver({required bool val}) {
    log("update is with driver called");
    isWithDriver = val;
    notifyListeners();
  }

  updateCurrentOrderStatus({required int val}) {
    currentOrderStatus = val;
    session.setOrderStatus = val;
    // Active ride shuru hone par customer_current marker hata do (blue dot kaafi hai)
    if (val > 0) markers.remove(const MarkerId("customer_current"));
    notifyListeners();
  }

  addChatAll(List<ChatModel> list) {
    _chatMessagesList = list;
    notifyListeners();
  }

  addSingleChat(ChatModel chat) {
    log("my single chat data is:-->> $chat");
    print("my single chat data is:-->> $chat");
    _chatMessagesList.insert(0, chat);
    notifyListeners();
  }

  updateUnReadMessages({required int count}) {
    unreadMessageCount = count;
    log("un read message count is:-->> $unreadMessageCount");
    print("un read message count is:-->> $unreadMessageCount");
    notifyListeners();
  }

  /** update driver details model */
  Future<void> updateDriverDetailsModel({required DriverDetailResponseModel data}) async {
    driverDetailResponseModel = data;
    notifyListeners();
  }

  //clear state
  FutureOr<void> clearState() async {
    await sessionClearOrder();
    stopCustomerLocationTracking();
    _driverAnimTimer?.cancel();
    _driverAnimTimer = null;
    _previousDriverLatLng = null;
    polylines.clear();
    markers.clear();
    isWithDriver = false;
    originIsFilled = false;
    originAddress = 'Pickup Address';
    notifyListeners();
  }

  /// Customer ki apni live location track karta hai aur map mein update karta hai.
  /// Isse customer apni current position map par dekhta hai.
  Future<void> startCustomerLocationTracking() async {
    _customerLocationSubscription?.cancel();
    try {
      bool serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationService.requestService();
        if (!serviceEnabled) return;
      }
      lctn.PermissionStatus permissionStatus = await locationService.hasPermission();
      if (permissionStatus == lctn.PermissionStatus.denied) {
        permissionStatus = await locationService.requestPermission();
        if (permissionStatus != lctn.PermissionStatus.granted) return;
      }

      await locationService.changeSettings(
        accuracy: lctn.LocationAccuracy.high,
        interval: 3000,
        distanceFilter: 10,
      );

      _customerLocationSubscription = locationService.onLocationChanged.listen((lctn.LocationData locationData) {
        if (locationData.latitude == null || locationData.longitude == null) return;
        final customerLatLng = LatLng(locationData.latitude!, locationData.longitude!);

        // Sirf searching (status 0) mein custom marker dikhao
        // Active ride mein myLocationEnabled: true ka blue dot enough hai
        if (currentOrderStatus == 0) {
          const markerId = MarkerId("customer_current");
          markers[markerId] = Marker(
            markerId: markerId,
            position: customerLatLng,
            icon: initialMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            anchor: const Offset(0.5, 0.5),
            zIndexInt: 1,
          );
          notifyListeners();
        }
      });
    } catch (e) {
      logMe("startCustomerLocationTracking error: $e");
    }
  }

  void stopCustomerLocationTracking() {
    _customerLocationSubscription?.cancel();
    _customerLocationSubscription = null;
  }

  /// Returns true only when the Flutter app is in the foreground (resumed state).
  /// Used to skip local notifications in background — FCM system notification
  /// already covers that case, so showing another local notification would duplicate it.
  bool _isAppInForeground() {
    final state = WidgetsBinding.instance.lifecycleState;
    return state == AppLifecycleState.resumed;
  }

  // -----> function to connect the socket <--------- //
  Future<void> connectToSocket() async {
    if (isConnected) {
      return;
    }
    print("-------->CONNECTING TO SOCKET <--------");
    print('Socket Url===>>>> "https://api.gatsbyrideshare.com" token=${session.sessionToken.isNotEmpty ? "[JWT set]" : "EMPTY"} userID=${session.userId}');

    _socket = IO.io(
      'https://api.gatsbyrideshare.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({
            'token': session.sessionToken,
            'room': '0',
            'userID': session.userId,
          })
          .setReconnectionDelay(3000)      // 3 sec baad retry
          .setReconnectionDelayMax(15000)  // max 15 sec wait
          .setReconnectionAttempts(10)     // 10 baar try karo
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      isConnected = true;
      _isListening = false;
      print("************ Connected ***********");
      listenSocketRequests();
      if (_pendingRideRequest != null) {
        _socket!.emit('message', _pendingRideRequest);
        print("Pending ride request sent on connect: $_pendingRideRequest");
        _pendingRideRequest = null;
      }
    });

    _socket!.onDisconnect((_) {
      isConnected = false;
      _isListening = false;
      print("************ Disconnected ***********");
    });

    _socket!.onConnecting((_) {
      isConnected = false;
      print("************ CONNECTING ***********");
    });

    _socket!.onReconnecting((_) {
      isConnected = false;
      print("************ Reconnecting ***********");
    });

    _socket!.onReconnect((_) {
      isConnected = true;
      // Note: onConnect also fires after reconnect — let onConnect handle
      // listenSocketRequests() and pendingRideRequest to avoid duplicates.
      print("************ Reconnected ***********");

      // Re-emit UserBookDriver if still searching (status 0) and no pending stored
      if (session.orderStatus == 0 &&
          session.isRunningOrder &&
          _pendingRideRequest == null &&
          session.orderId.isNotEmpty) {
        final paymentStr = session.bookingPaymentMethod == 1 ? "cash" : "card";
        final reEmitMap = {
          'serviceType': 'UserBookDriver',
          'UserID': session.userId,
          'OrderID': session.orderId,
          'vehicle_category_id': int.tryParse(session.bookingVehicleCategoryId) ?? session.bookingVehicleCategoryId,
          'start_coordinate': '${session.originLat},${session.originLong}',
          'end_coordinate': '${session.destinationLat},${session.destinationLong}',
          'start_address': session.originAddress,
          'end_address': session.destinationAddress,
          'estimated_time': session.estimatedTime.isNotEmpty ? session.estimatedTime : "0.0",
          'distance': session.estimatedDistance,
          'total': session.rideTotal,
          'payment_method': paymentStr,
        };
        _socket!.emit('message', reEmitMap);
        print("UserBookDriver re-emitted after reconnect: $reEmitMap");
      }
    });

    _socket!.onConnectError((data) {
      isConnected = false;
      _isListening = false;
      print("************ Connect Error: $data ***********");
    });

    _socket!.onError((data) {
      isConnected = false;
      _isListening = false;
      print("************ Socket Error: $data ***********");
    });

    _socket!.connect();
  }

  void listenSocketRequests() {
    if (_isListening) {
      print("************ Already listening, skipping duplicate ***********");
      return;
    }
    _isListening = true;

    // Remove any stale listeners from previous connections before adding new one
    _socket!.off('message');

    print("************ listen to socket called");
    _socket!.on('message', (event) async {
      try {
      final response = event is String ? jsonDecode(event) : event;
      final eventType = response['type'] ?? 'UNKNOWN';
      print('');
      print('🔔 ========== SOCKET EVENT: $eventType ==========');
      print('----- Event Messages ===============\n  ${response.toString()} \n ===============');

      // <----------- Checking When request come ---------> //
      if (response['type'] == 'CustomerBookRequest') {
        bookingDataModel = BookingDataModel.fromJson(response);
        print("order id is :--->> ${bookingDataModel!.data.id} and Customer Id  is:--->> ${bookingDataModel!.data.customerId}");
        if (bookingDataModel!.data.customerId == session.userId) {
          final receivedId = bookingDataModel!.data.id?.toString() ?? '';
          if (receivedId.isNotEmpty && receivedId != '0') {
            session.setOrderId = receivedId;
          }
          final oriLatLng = LatLng(
            double.tryParse(bookingDataModel!.data.startCoordinate.split(",").first) ?? 0.0,
            double.tryParse(bookingDataModel!.data.startCoordinate.split(",").last) ?? 0.0,
          );
          final destLatLng = LatLng(
            double.tryParse(bookingDataModel!.data.endCoordinate.split(",").first) ?? 0.0,
            double.tryParse(bookingDataModel!.data.endCoordinate.split(",").last) ?? 0.0,
          );
          updateOriginAndDestinationLatLong(origin: oriLatLng, destination: destLatLng);
        }
        notifyListeners();
      }

      /// *************** DRIVER UPDATED LAT LONG ********* -------
      else if (response['type'] == 'UpdatedLatLong' || response['serviceType'] == 'UpdatedLatLong') {
        log(response['type']);
        log("****************************      DRIVER UPDATED THE LAT LNG *************************");
        driverUpdatedPositionModel = DriverUpdatedPositionModel.fromJson(response);
        updateDriverLatLng(driverLtLng: LatLng(driverUpdatedPositionModel!.latitude, driverUpdatedPositionModel!.longitude));
        session.setDriverLatLong = "${driverUpdatedPositionModel!.latitude},${driverUpdatedPositionModel!.longitude}";
        final parsedBearing = double.tryParse(driverUpdatedPositionModel!.bearing?.toString() ?? '0') ?? 0.0;
        updateBearing(val: parsedBearing);
        if (driverUpdatedPositionModel!.status == 3 || driverUpdatedPositionModel!.status == 5) {
          updateIsWithDriver(val: true);
          isWithDriver = true;
        }
        if (session.isRunningOrder || currentOrderStatus > 0) {
          await trackingDriver(
              listenLocation: true,
              lat: driverUpdatedPositionModel!.latitude,
              bearing: bearing,
              long: driverUpdatedPositionModel!.longitude);
        }
        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** RIDE ACCEPTED ********* -------
      else if (response['type'] == 'Accept') {
        log("****************************      DRIVER ACCEPTED THE RIDE *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);

        updateOrderDetailsModel(
          data: OrderDetailResponseModel(
            success: 1,
            data: OrderDetail(
                phone: acceptResponseModel!.data.phoneNumber.toString(),
                distance: acceptResponseModel!.data.distance.toString(),
                driverId: acceptResponseModel!.data.driverId.toString(),
                endAddress: acceptResponseModel!.data.endAddress.toString(),
                endCoordinate: acceptResponseModel!.data.endCoordinate.toString(),
                orderId: acceptResponseModel!.data.id.toString(),
                startAddress: acceptResponseModel!.data.startAddress.toString(),
                startCoordinate: acceptResponseModel!.data.startCoordinate.toString(),
                totalPrice: acceptResponseModel!.data.total.toString(),
                userId: session.userId.toString(),
                orderStatus: "1"),
          ),
        );

        updateDriverDetailsModel(
          data: DriverDetailResponseModel(
              success: 1,
              message: Message(
                id: acceptResponseModel!.data.driverId!.toString(),
                name: acceptResponseModel!.data.name!.toString(),
                image: acceptResponseModel!.data.profilePhoto!.toString(),
                phone: acceptResponseModel!.data.phoneNumber!.toString(),
                carModel: acceptResponseModel!.data.carModel!.toString(),
                plateNumber: acceptResponseModel!.data.plateNumber!.toString(),
                rating: acceptResponseModel!.data.driverRating!.toString(),
              )),
        );
        log("aceeep sdf name==>>${acceptResponseModel!.data.name}");
        session.setOrderId = acceptResponseModel!.data.id.toString();
        session.setDriverId = acceptResponseModel!.data.driverId.toString();
        updateIsOrderAccepted(val: true);
        session.setOrderStatus = 1;
        currentOrderStatus = 1;
        updateCurrentOrderStatus(val: 1);
        session.setIsRunningOrder = true;

        log("origin lat -->> ${acceptResponseModel!.data.startCoordinate}");
        log("origin lat -->> ${acceptResponseModel!.data.endCoordinate}");

        session.setOriginAddress = acceptResponseModel!.data.startAddress;
        session.setDestinationAddress = acceptResponseModel!.data.endAddress;
        session.setOriginLat = double.tryParse(acceptResponseModel!.data.startCoordinate.split(',').first) ?? 0.0;
        session.setOriginLong = double.tryParse(acceptResponseModel!.data.startCoordinate.split(',').last) ?? 0.0;
        session.setDestinationLat = double.tryParse(acceptResponseModel!.data.endCoordinate.split(',').first) ?? 0.0;
        session.setDestinationLong = double.tryParse(acceptResponseModel!.data.endCoordinate.split(',').last) ?? 0.0;
        updateIsWithDriver(val: false);
        isWithDriver = false;

        // Draw car + route immediately if Accept response includes real driver position.
        final acceptDriverLat = double.tryParse(acceptResponseModel!.data.latitude.toString()) ?? 0.0;
        final acceptDriverLng = double.tryParse(acceptResponseModel!.data.longitude.toString()) ?? 0.0;
        // Backend kabhi kabhi pickup coords ko driver position ki jagah bhejta hai —
        // agar ye pickup location ke same hain to skip karo, real UpdatedLatLong ka wait karo.
        final bool isPickupCoords =
            (acceptDriverLat - session.originLat).abs() < 0.0001 &&
            (acceptDriverLng - session.originLong).abs() < 0.0001;
        if (!isPickupCoords && (acceptDriverLat != 0.0 || acceptDriverLng != 0.0)) {
          session.setDriverLatLong = "$acceptDriverLat,$acceptDriverLng";
          try {
            await trackingDriver(listenLocation: true, lat: acceptDriverLat, long: acceptDriverLng, bearing: bearing);
          } catch (e) {
            logMe("Accept trackingDriver error: $e");
          }
        }

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** DEPARTURE TO CUSTOMER ********* -------
      else if (response['type'] == 'DepartToCustomer') {
        log("****************************     DRIVER DEPARTURE TO CUSTOMER *************************");
        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id.toString();
        final bool isNewDeparture = session.orderStatus < 2;
        session.setOrderStatus = 2;
        currentOrderStatus = 2;
        updateCurrentOrderStatus(val: 2);
        session.setDriverId = acceptResponseModel!.data.driverId.toString();
        updateIsWithDriver(val: false);
        isWithDriver = false;
        session.setIsRunningOrder = true;
        currentOrderStatus = 2;
        await _trackFromStatusEvent(acceptResponseModel!);
        notifyListeners();
        // Foreground mein hi local notification dikhao.
        // Background mein FCM system notification khud show karta hai —
        // socket + FCM dono saath fire hone se duplicate banta tha.
        if (isNewDeparture && _isAppInForeground() && 2 > _lastNotifiedStatus) {
          _lastNotifiedStatus = 2;
          NotificationHelper().showLocalNotification(
            title: "Driver On the Way",
            body: "Your driver is heading to your pickup location.",
          );
        }
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** REACH TO CUSTOMER LOCATION  ********* -------
      else if (response['type'] == 'reachLocation') {
        log("****************************      DRIVER REACH YOUR LOCATION *************************");
        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id.toString();
        final bool isNewReach = session.orderStatus < 3;
        session.setOrderStatus = 3;
        session.setDriverId = acceptResponseModel!.data.driverId.toString();
        updateIsWithDriver(val: true);
        isWithDriver = true;
        session.setIsRunningOrder = true;
        currentOrderStatus = 3;
        updateCurrentOrderStatus(val: 3);
        await _trackFromStatusEvent(acceptResponseModel!);
        notifyListeners();
        if (isNewReach && _isAppInForeground() && 3 > _lastNotifiedStatus) {
          _lastNotifiedStatus = 3;
          NotificationHelper().showLocalNotification(
            title: "Driver Arrived",
            body: "Your driver has reached your pickup location. Please come outside.",
          );
        }
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** START TRIP  ********* -------
      else if (response['type'] == 'startTrip') {
        log("****************************      DRIVER START THE RIDE *************************");
        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id.toString();
        final bool isNewTrip = session.orderStatus < 5;
        session.setOrderStatus = 5;
        session.setDriverId = acceptResponseModel!.data.driverId.toString();
        updateIsWithDriver(val: true);
        isWithDriver = true;
        currentOrderStatus = 5;
        session.setIsRunningOrder = true;
        await _trackFromStatusEvent(acceptResponseModel!);
        notifyListeners();
        if (isNewTrip && _isAppInForeground() && 5 > _lastNotifiedStatus) {
          _lastNotifiedStatus = 5;
          NotificationHelper().showLocalNotification(
            title: "Ride Started",
            body: "Your ride has started. Enjoy your trip!",
          );
        }
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** END TRIP  ********* -------
      else if (response['type'] == 'endTrip') {
        log("****************************      DRIVER END THE RIDE *************************");
        final bool isNewEnd = session.orderStatus < 7;
        session.setOrderStatus = 7;
        currentOrderStatus = 7;
        updateCurrentOrderStatus(val: 7);
        print(response);
        updateReceiptResponseModel(ReceiptResponseModel.fromJson(response));
        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id.toString();
        saveOrderReceipt();
        notifyListeners();
        if (isNewEnd && _isAppInForeground() && 7 > _lastNotifiedStatus) {
          _lastNotifiedStatus = 7;
          NotificationHelper().showLocalNotification(
            title: "Ride Completed",
            body: "Your ride has ended. Thank you for riding with Gatsby!",
          );
        }
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** DRIVER CANCEL THE RIDE  ********* -------
      else if (response['type'] == 'Reject') {
        log("****************************      DRIVER CANCEL THE RIDE *************************");

        if (response["data"]["driverID"] != null) {
          acceptResponseModel = AcceptResponseModel.fromJson(response);
          session.setOrderId = acceptResponseModel!.data.id.toString();
          session.setOrderStatus = 8;
          currentOrderStatus = 8;
          updateCurrentOrderStatus(val: 8);

          notifyListeners();
          if (_isAppInForeground()) {
            NotificationHelper().showLocalNotification(
              title: "Ride Cancelled",
              body: "Your driver has cancelled the ride. Please search for another driver.",
            );
          }
          showDialog(
            barrierDismissible: false,
            context: locator<GlobalKey<NavigatorState>>().currentContext!,
            builder: (BuildContext context) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
                  title: Text("Ride is Cancelled by the Driver"),
                  actions: [
                    ElevatedButton(
                      child: Text("Find Next Driver"),
                      onPressed: () async {
                        session.setIsRunningOrder = false;
                        _homeProvider.clearState();
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      },
                    ),
                  ],
                ),
              );
            },
          );

          log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
        }
      }

      // <----------- Checking When request come ---------> //
      else if (response['type'] == 'MessageList') {
        isLoading = false;
        notifyListeners();
        log("messgae type is MESSAGE LIST");
        print("messgae type is MESSAGE LIST");
        log('Message list data-----> ${response['data']}');

        if (response['data'] != null) {
          final list = List<ChatModel>.from(
            response["data"].map((x) => ChatModel.fromMap(x)),
          );
          addChatAll(list.reversed.toList());
          log("chat data is :-->>${chatMessageList.length}");
          print("chat data is :-->>${chatMessageList.length}");
        } else {
          addChatAll([]);
        }
      } else if (response['type'] == 'Chat') {
        final chatData = response['data'] ?? response;
        addSingleChat(ChatModel.fromMap(chatData));
        log("chat data is :-->>${chatMessageList.length}");
        if (!isChatPageOpen && _isAppInForeground()) {
          NotificationHelper().showLocalNotification(
            title: "New Message",
            body: chatData['message'] ?? chatData['msg'] ?? "You have a new message",
          );
        }
      } else if (response['type'] == 'UnreadCount') {
        log("unread message count called");
        updateUnReadMessages(count: response['data']);
      }
      } catch (e, stack) {
        log("⚠️ Socket message handler ERROR: $e");
        log("⚠️ Stack: $stack");
      }
    });
  }

  /// Updates origin/destination from a status event response (if valid) then
  /// immediately draws the car marker + route without waiting for UpdatedLatLng.
  Future<void> _trackFromStatusEvent(AcceptResponseModel model) async {
    final oriLat = double.tryParse(model.data.startCoordinate.split(',').first) ?? 0.0;
    final oriLng = double.tryParse(model.data.startCoordinate.split(',').last) ?? 0.0;
    final destLat = double.tryParse(model.data.endCoordinate.split(',').first) ?? 0.0;
    final destLng = double.tryParse(model.data.endCoordinate.split(',').last) ?? 0.0;
    if ((oriLat != 0.0 || oriLng != 0.0) && (destLat != 0.0 || destLng != 0.0)) {
      updateOriginAndDestinationLatLong(
        origin: LatLng(oriLat, oriLng),
        destination: LatLng(destLat, destLng),
      );
    }
    var dLat = double.tryParse(model.data.latitude.toString()) ?? 0.0;
    var dLng = double.tryParse(model.data.longitude.toString()) ?? 0.0;
    // Fallback to last known driver position if event doesn't include coordinates.
    if (dLat == 0.0 && dLng == 0.0) {
      final parts = session.driverLatLng.split(',');
      if (parts.length == 2) {
        dLat = double.tryParse(parts[0].trim()) ?? 0.0;
        dLng = double.tryParse(parts[1].trim()) ?? 0.0;
      }
    }
    if (dLat != 0.0 || dLng != 0.0) {
      session.setDriverLatLong = "$dLat,$dLng";
      try {
        await trackingDriver(listenLocation: true, lat: dLat, long: dLng, bearing: bearing);
      } catch (e) {
        logMe("_trackFromStatusEvent error: $e");
      }
    }
  }

  // /**  Tracking Driver */
  Future<void> trackingDriver(
      {required bool listenLocation,
      required double lat,
      required double long,
      required double bearing}) async {
    log("driver:- tracking driver called-->>>>>. ${lat} ${long}");
    log("driver:- is listenLocation :$listenLocation");
    updateDriverLatLng(driverLtLng: LatLng(lat, long));
    var latDriver = lat;
    var lngDriver = long;

    const MarkerId markerId = MarkerId("driver");
    final LatLng newDriverPos = LatLng(latDriver, lngDriver);

    // Smooth animation: agar pehle position hai to slide karo, warna seedha place karo
    if (_previousDriverLatLng != null &&
        (_previousDriverLatLng!.latitude != newDriverPos.latitude ||
         _previousDriverLatLng!.longitude != newDriverPos.longitude)) {
      _animateDriverMarker(_previousDriverLatLng!, newDriverPos, bearing);
    } else {
      markers[markerId] = Marker(
        markerId: markerId,
        position: newDriverPos,
        icon: driverMarker ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
        zIndexInt: 2,
        rotation: bearing,
        onTap: () {},
      );
      notifyListeners();
    }
    _previousDriverLatLng = newDriverPos;

    if (listenLocation && (session.isRunningOrder || currentOrderStatus > 0)) {
      logMe("is with driver called:-->> ${isWithDriver}");
      if ((isWithDriver) ||
          (currentOrderStatus == 5) ||
          (currentOrderStatus == 7) ||
          (currentOrderStatus == 3)) {
        log("driver:-  is with driver. $isWithDriver");
        log("driver:- destination LatLng. $destinationLatLng");
        if (destinationLatLng != null) {
          await setPolyLinesDirection(LatLng(latDriver, lngDriver), destinationLatLng!);
          await animateToBounds(LatLng(latDriver, lngDriver), destinationLatLng!);
        } else {
          await animateToLocation(LatLng(latDriver, lngDriver));
        }
      } else {
        log("driver:-  is not with driver. $isWithDriver");
        log("driver:-  is not with driver.origin lat long $originLatLng");
        if (originLatLng != null) {
          // Accept event echoes pickup coords as driver position — that gives a
          // zero-length polyline. Draw the full origin→destination route instead
          // until UpdatedLatLng events arrive with the real driver position.
          final bool driverAtPickup =
              (latDriver - originLatLng!.latitude).abs() < 0.0001 &&
              (lngDriver - originLatLng!.longitude).abs() < 0.0001;
          if (driverAtPickup && destinationLatLng != null) {
            await setPolyLinesDirection(originLatLng!, destinationLatLng!);
          } else {
            await setPolyLinesDirection(LatLng(latDriver, lngDriver), originLatLng!);
          }
          await animateToBounds(LatLng(latDriver, lngDriver), originLatLng!);
        } else {
          await animateToLocation(LatLng(latDriver, lngDriver));
        }
      }
    } else {
      await animateToLocation(LatLng(latDriver, lngDriver));
    }
  }

  // Driver marker ko smoothly animate karo (Ola/Uber jaise sliding movement)
  void _animateDriverMarker(LatLng from, LatLng to, double targetBearing) {
    _driverAnimTimer?.cancel();
    const int steps = 20;
    int step = 0;
    final double latStep = (to.latitude - from.latitude) / steps;
    final double lngStep = (to.longitude - from.longitude) / steps;

    _driverAnimTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      step++;
      final LatLng pos = step >= steps
          ? to
          : LatLng(from.latitude + latStep * step, from.longitude + lngStep * step);
      markers[const MarkerId("driver")] = Marker(
        markerId: const MarkerId("driver"),
        position: pos,
        icon: driverMarker ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
        zIndexInt: 2,
        rotation: targetBearing,
        onTap: () {},
      );
      notifyListeners();
      if (step >= steps) timer.cancel();
    });
  }

  // Save UserData to SharedPreferences
  void saveOrderReceipt() {
    session.setIsPaymentDone = false;
    session.setIsRatingGiven = false;
    logMe("save order receipt called");

    if (receiptResponseModel != null) {
      logMe("save order receipt called receiptResponseModel ==== NOT NULL");
      session.setOrderReceipt = json.encode(receiptResponseModel!);
    }
  }

  Future<void> animateToLocation(LatLng position) async {
    try {
      await googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: position,
        bearing: bearing,
        zoom: zoom,
      )));
    } catch (e) {
      logMe("UNABLE TO ANIMATE");
    }
  }

  Future<void> animateToBounds(LatLng driverPos, LatLng waypoint) async {
    try {
      final double south = driverPos.latitude < waypoint.latitude ? driverPos.latitude : waypoint.latitude;
      final double north = driverPos.latitude > waypoint.latitude ? driverPos.latitude : waypoint.latitude;
      final double west = driverPos.longitude < waypoint.longitude ? driverPos.longitude : waypoint.longitude;
      final double east = driverPos.longitude > waypoint.longitude ? driverPos.longitude : waypoint.longitude;
      final bounds = LatLngBounds(
        southwest: LatLng(south - 0.005, west - 0.005),
        northeast: LatLng(north + 0.005, east + 0.005),
      );
      await googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
    } catch (e) {
      logMe("animateToBounds error: $e");
      await animateToLocation(driverPos);
    }
  }

  Future<void> setPolyLinesDirection(LatLng origin, LatLng destination) async {
    log("polyline///  --Driver co:" + origin.latitude.toString() + "," + origin.longitude.toString());
    log("polyline/// destination co:" + destination.latitude.toString() + "," + destination.longitude.toString());

    // Draw a straight line immediately so something always shows while API loads.
    polylines = {
      Polyline(
        polylineId: const PolylineId("jalur"),
        color: Colors.black,
        points: [origin, destination],
        width: 6,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      )
    };
    notifyListeners();

    // Replace with proper road route when Directions API responds.
    await DirectionHelper()
        .getRouteBetweenCoordinates(origin.latitude, origin.longitude,
            destination.latitude, destination.longitude)
        .then((result) {
      log("Polyline results are ::::::::--------------  ${result} ------------********");
      if (result.isNotEmpty) {
        polylineCoordinates = [];
        for (var point in result) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        polylines = {
          Polyline(
            polylineId: const PolylineId("jalur"),
            color: Colors.black,
            points: polylineCoordinates,
            width: 6,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          )
        };
        log("Polylines are:-->> " + polylines.toString());
      }
      notifyListeners();
    });
  }

  // ✅ FIX 7: createRideRequest mein connection check add kiya
  Future<bool> createRideRequest({
    required originLatLngs,
    required destinationLatLngs,
    required vehicleCatagory,
    required startAddress,
    required endAddress,
    required estimatedTime,
    required distance,
    required total,
    required payment_method,
  }) async {
    try {
      final map = {
        'serviceType': 'UserBookDriver',
        'UserID': session.userId,
        'OrderID': session.orderId,
        'vehicle_category_id': vehicleCatagory,
        'start_coordinate': originLatLngs,
        'end_coordinate': destinationLatLngs,
        'start_address': startAddress,
        'end_address': endAddress,
        'estimated_time': estimatedTime,
        'distance': distance,
        'total': total,
        'payment_method': payment_method,
      };

      if (_socket == null) {
        print("Socket is null! Reconnecting...");
        await connectToSocket();
        await Future.delayed(Duration(seconds: 2));
      }

      // Connected hai to directly send karo
      if (_socket!.connected) {
        _socket!.emit('message', map);
        _pendingRideRequest = null;
        print("UserBookDriver ===========>>> ${map.toString()}");
        logMe('CONNECTED:-->> Send New ride request -- > ${map.toString()}');
        notifyListeners();
        return true;
      } else {
        // Socket connected nahi — request store karo, reconnect hone pe automatically jayega
        print("Socket not connected, storing ride request for retry on reconnect...");
        _pendingRideRequest = map;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error creating ride request: $e');
      return false;
    }
  }

  // /** -------------------*************************** CANCEL RIDE BY CUSTOMER  ******************----------------- */
  Future<bool> cancelRideByCustomer() async {
    try {
      _pendingRideRequest = null;
      final map = {
        'serviceType': 'CancelByUser',
        'UserID': session.userId,
        'OrderID': session.orderId
      };
      logMe('cancelRideByCustomer -- > ${map.toString()}');
      print('cancelRideByCustomer -- > ${map.toString()}');

      _socket!.emit('message', map);
      session.setSearchingTime = 30;

      return true;
    } catch (e) {
      return false;
    }
  }

  //   //Get total number of unread message
  void getTotalUnreadCount(int? receiverId) {
    log("get total count");
    final map = {
      "userID": session.userId,
      "serviceType": "UnreadCount",
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "UserType": 'Customer'
    };

    if (_socket!.connected) {
      log("socket is connected ==>>unread count ");
      log("get total count:" + map.toString());
      _socket!.emit('message', map);
    } else {
      log("socket not connected: ${_socket!.id}");
    }
  }

  /** Get Order Details */
  Future<OrderDetailResponseModel?> fetchOrderDetails(int id) async {
    log("fetch order details called");
    if (id <= 0) {
      log("fetchOrderDetails: invalid id=$id, skipping API call");
      return null;
    }
    final String apiUrl =
        'https://api.gatsbyrideshare.com/api/webservice/getOrder?id=$id';

    try {
      log("try called : ${apiUrl}");
      final response = await Dio().get(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer ${session.sessionToken}'},
        ),
      );
      log("--------******* ${response.data}");

      if (response.statusCode == 200) {
        dismissLoading();
        log("api/webservice/getOrder response is :${response}");
        OrderDetailResponseModel data =
            OrderDetailResponseModel.fromJson(response.data);
        updateReceiptResponseModel(ReceiptResponseModel.fromJson(response.data),
            addData: true);
        session.setOrderStatus =
            int.parse(data.data.orderStatus.toString());

        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  /** Get DRIVER Details */
  Future<DriverDetailResponseModel> fetchDriverDetails(int id) async {
    showLoading();

    final String apiUrl =
        'https://api.gatsbyrideshare.com/api/webservice/driver-profile?id=$id';
    final String authToken = session.sessionToken;

    print("get driver details $apiUrl");

    try {
      final response = await Dio().get(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      if (response.statusCode == 200) {
        dismissLoading();
        log("driver details are:-->> ${response.data}");
        DriverDetailResponseModel data =
            DriverDetailResponseModel.fromJson(response.data);
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void joinExitRoom({int? receiverId, required String type}) {
    print("chat page join exit room called");
    print("connection state: connected=${_socket!.connected}");
    log('-----Event  connected=${_socket!.connected}');
    log('connection state  connected=${_socket!.connected}');

    log("join socket called $type");
    print("join socket called $type");

    if (type == 'Join') {
      isLoading = true;
      isChatPageOpen = true;
      _chatMessagesList = [];
      markMessageAsRead(receiverId: receiverId);
      Future.delayed(const Duration(seconds: 6), () {
        if (isLoading) {
          isLoading = false;
          notifyListeners();
        }
      });
    } else if (type == 'unJoin') {
      isChatPageOpen = false;
      updateUnReadMessages(count: 0);
      clearChatList();
    }

    final map = {
      'type': 'Customer',
      'serviceType': type,
      'UserID': session.userId,
      'roomID': (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
    };
    logMe('Join Exit room socket -- > ${map.toString()}');
    print('Join Exit room socket -- > ${map.toString()}');

    _socket!.emit('message', map);
    notifyListeners();
  }

  void markMessageAsRead({int? receiverId}) {
    log("mark message as read  called");
    print("mark message as read  called");

    final map = {
      "userID": session.userId,
      "serviceType": "",
      "recieverID": receiverId,
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "SenderType": "Customer",
      "RecieverType": "Driver",
      "type": "read"
    };

    print("mark as read $map");
    _socket!.emit('message', map);
  }

  void clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
  }

  void sendChatMessage({
    String? message,
    int? receiverId,
    String? messageType = 'Text',
  }) {
    final map = {
      "userID": session.userId,
      "serviceType": "Chat",
      "recieverID": receiverId,
      "msg": message,
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "MessageType": "Text",
      "SenderType": "Customer",
      "RecieverType": "Driver",
      "type": "Chat"
    };
    print('Message send ---> ${map.toString()}');

    _socket!.emit('message', map);
    addSingleChat(
      ChatModel(
        id: session.orderId,
        messageType: 'Text',
        roomId: (int.parse(session.userId) > receiverId)
            ? '$receiverId-${session.userId}'
            : '${session.userId}-$receiverId',
        message: message,
        senderType: 'Customer',
        recieverType: 'Driver',
        sourceUserId: session.userId,
        targetUserId: receiverId.toString(),
        createdOn: DateTime.now(),
        modifiedOn: DateTime.now(),
      ),
    );
  }

  Future<SubmitRatingsResponseModel> submitRatings(FormData formData) async {
    String url = 'https://api.gatsbyrideshare.com/api/webservice/order/rating';
    dio.options.headers["Authorization"] = "Bearer ${session.sessionToken}";
    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = SubmitRatingsResponseModel.fromJson(response.data);
      dismissLoading();
      return model;
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> setCurrentLocation(OrderDataDetail orderDataDetail) async {
    log("set current location called :$orderDataDetail");
    try {
      bool serviceStatus = await locationService.serviceEnabled();
      if (serviceStatus) {
        await setAddressFromLatLng(orderDataDetail);
      } else {
        try {
          bool serviceStatusResult = await locationService.requestService();
          logMe("Service status activated after request: $serviceStatusResult");
          if (serviceStatusResult) {
            setCurrentLocation(orderDataDetail);
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

  void callDriver() async {
    final call =
        Uri.parse('tel:${orderDetailResponseModel?.data.phone ?? '9876543210'}');
    launchUrl(call);
  }

  Future<void> setAddressFromLatLng(OrderDataDetail orderDataDetail) async {
    log("set address from lat long  ORDER DETAILS : ${orderDataDetail}");
    try {
      MarkerId markerIdOrigin = const MarkerId("origin");
      MarkerId markerIdDestination = const MarkerId("destination");
      final Marker markerOrigin = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: markerIdOrigin,
        position: LatLng(orderDataDetail.originLatLng.latitude,
            orderDataDetail.originLatLng.longitude),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: initialMarker ?? BitmapDescriptor.defaultMarker,
        onTap: () {},
      );
      final Marker markerDestination = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: markerIdDestination,
        position: LatLng(orderDataDetail.destinationLatLng.latitude,
            orderDataDetail.destinationLatLng.longitude),
        infoWindow: const InfoWindow(title: "destination"),
        icon: destinationMarker ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () {},
      );

      googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(orderDataDetail.originLatLng.latitude,
            orderDataDetail.originLatLng.longitude),
        zoom: zoom,
      )));

      originAddress = orderDataDetail.originAddress;
      destinationAddress = orderDataDetail.destinationAddress;
      originLatLng = orderDataDetail.originLatLng;
      destinationLatLng = orderDataDetail.destinationLatLng;
      markers[markerIdOrigin] = markerOrigin;
      markers[markerIdDestination] = markerDestination;
      notifyListeners();
    } catch (e) {
      logMe(e);
    }
  }

  Future<void> updateBitsImage() async {
    await getBytesFromAsset(initialPickUpIcon, 80).then((value) async {
      initialMarker = BitmapDescriptor.bytes(value);
    });
    await getBytesFromAsset(destinationIcon, 40).then((value) async {
      destinationMarker = BitmapDescriptor.bytes(value);
    });
    await getBytesFromAsset(carIconAsset, 60).then((value) {
      driverMarker = BitmapDescriptor.bytes(value);
    });
  }

  void updateOriginAndDestinationLatLong(
      {required LatLng origin, required LatLng destination}) {
    originLatLng = origin;
    destinationLatLng = destination;
    notifyListeners();
  }


  Future<void> moveCameraToDriver() async {
    await animateToLocation(LatLng(_driverLat, _driverLng));
  }

  void restoreOrderStatusFromSession() {
    final status = session.orderStatus;
    if (status > 0 && status != 100) {
      currentOrderStatus = status;
      // Prevent re-showing notifications for statuses already seen before this
      // session (e.g. app killed and relaunched mid-ride).
      if (status > _lastNotifiedStatus) _lastNotifiedStatus = status;
      if (status == 3 || status == 5 || status == 7) {
        isWithDriver = true;
      }
    }
    notifyListeners();
  }

  Future<void> restoreDriverPositionOnMapReady() async {
    try {
      if (!session.isRunningOrder) return;
      final driverPos = session.driverLatLng;
      final parts = driverPos.split(',');
      if (parts.length != 2) return;
      final driverLat = double.tryParse(parts[0].trim()) ?? 0.0;
      final driverLng = double.tryParse(parts[1].trim()) ?? 0.0;
      if (driverLat == 0.0 && driverLng == 0.0) return;
      await trackingDriver(
        listenLocation: true,
        lat: driverLat,
        long: driverLng,
        bearing: bearing,
      );
    } catch (e) {
      logMe("restoreDriverPositionOnMapReady error: $e");
    }
  }

  /// App background se foreground mein aane par API se latest ride status sync karta hai.
  /// Socket.IO background mein disconnect ho jaata hai, isliye yeh method missed events cover karta hai.
  Future<void> syncStatusFromApi() async {
    if (!session.isRunningOrder || session.orderId.isEmpty) return;
    log("syncStatusFromApi: checking API for latest ride status");
    try {
      final orderId = int.tryParse(session.orderId);
      if (orderId == null) return;

      final data = await fetchOrderDetails(orderId);
      if (data == null) return;

      final apiStatus = int.tryParse(data.data.orderStatus.toString()) ?? 0;
      log("syncStatusFromApi: apiStatus=$apiStatus, currentStatus=$currentOrderStatus");

      if (apiStatus > currentOrderStatus) {
        log("syncStatusFromApi: updating status $currentOrderStatus → $apiStatus");
        currentOrderStatus = apiStatus;
        session.setOrderStatus = apiStatus;
        // Mark this status as already-notified (APNs showed it in background).
        // Prevents socket replay events after foreground from showing a duplicate banner.
        if (apiStatus > _lastNotifiedStatus) _lastNotifiedStatus = apiStatus;
        if (apiStatus == 3 || apiStatus == 5 || apiStatus == 7) {
          isWithDriver = true;
        }
        // Persist receipt to session so ReceiptScreen can load it after background→foreground
        if (apiStatus == 7) {
          saveOrderReceipt();
        }
        if (driverDetailResponseModel == null && session.driverId.isNotEmpty) {
          final driverId = int.tryParse(session.driverId);
          if (driverId != null) {
            try {
              final driverData = await fetchDriverDetails(driverId);
              await updateDriverDetailsModel(data: driverData);
            } catch (e) {
              logMe("syncStatusFromApi: driver details error: $e");
            }
          }
        }
        notifyListeners();
      }
    } catch (e) {
      logMe("syncStatusFromApi error: $e");
    }
  }
}