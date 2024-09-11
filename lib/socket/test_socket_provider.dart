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
import 'package:web_socket_client/web_socket_client.dart';
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

class TestSocketProvider extends ChangeNotifier {
  WebSocket? _socket;
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

  List<ChatModel> get chatMessageList => _chatMessagesList;
  late BitmapDescriptor pickUpMarker,
      destinationMarker,
      initialMarker,
      driverMarker;
  String originAddress = 'Pickup Address';
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  late LatLng originLatLng, destinationLatLng;
  final chatController = TextEditingController();
  String orderId = '';
  double bearing = 0.0;

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
      updateOriginAndDestinationLatLong(origin: oriLatLng, destination: destLatLng);
    }
    notifyListeners();
  }

  updateZoom(CameraPosition val) {
    zoom = val.zoom;
    notifyListeners();
  }

  //   // // Update rating and comments
  updateRatingComment({double? rating, String? comment}) {
    ratingGiven = rating!;
    commentGiven = comment!;
    notifyListeners();
  }

  updateBearing({
    val,
  }) {
    bearing = val;
    notifyListeners();
  }

  double _driverLat = 0.0;
  double _driverLng = 0.0;

  final lctn.Location locationService = lctn.Location();

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
    // }
  }

  updateCurrentOrderStatus({required int val}) {
    currentOrderStatus = val;
    session.setOrderStatus = val;

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
  Future<void> updateDriverDetailsModel(
      {required DriverDetailResponseModel data}) async {
    driverDetailResponseModel = data;
    notifyListeners();
  }

  //clear state
  FutureOr<void> clearState() async {
    await sessionClearOrder();
    polylines.clear();
    markers.clear();
    isWithDriver = false;
    originIsFilled = false;
    originAddress = 'Pickup Address';
    notifyListeners();
  }

  // -----> function to connect the socket <--------- //
  Future<void> connectToSocket() async {
    if(isConnected){
      return;
    }
    print("-------->CONNECTING TO SOCKET <--------");
    print('Socket Url===>>>> "ws://3.97.35.163:8051?token=${session.chatToken}&room=0&userID=${session.userId}""');
    _socket = WebSocket(Uri.parse("ws://3.97.35.163:8051?token=${session.chatToken}&room=0&userID=${session.userId}"));

    _socket!.connection.listen((event) {
      print("connection state is :-->. ${_socket!.connection.state}");
      if (event is Connected) {
        isConnected= true;
        print("************ Connected ***********");
        listenSocketRequests();
      } else if (event is Disconnected) {
        isConnected= false;
        print("************ Disconnected ***********");
        // showToast(message: "disconnected");
      } else if (event is Connecting) {
        isConnected= false;
        print("************ CONNECTING ***********");
        // showToast(message: "CONNECTING");
      } else if (event is Reconnecting) {
        isConnected= false;
        print("************ Reconnecting ***********");
      } else if (event is Reconnected) {
        isConnected= true;
        listenSocketRequests();
        print("************ Reconnected ***********");
      } else {
        isConnected= false;
        print("************ else $event ***********");
      }
    });
  }

  void listenSocketRequests() {
    print("************ listen to socket called");
    _socket!.messages.listen((event) async {
      final response = jsonDecode(event);
      print('----- Event Messages ===============\n  ${response.toString()} \n ===============');
      // <----------- Checking When request come ---------> //
      if (response['type'] == 'CustomerBookRequest') {
        bookingDataModel = BookingDataModel.fromJson(response);
        log("order id is :--->> ${bookingDataModel!.data.id} and Customer Id  is:--->> ${bookingDataModel!.data.customerId}");
        print("order id is :--->> ${bookingDataModel!.data.id} and Customer Id  is:--->> ${bookingDataModel!.data.customerId}");
        if (bookingDataModel!.data.customerId == session.userId) {
          session.setOrderId = bookingDataModel!.data.id;
          final oriLatLng = LatLng(
            double.tryParse(bookingDataModel!.data.startCoordinate.split(",").first) ?? 0.0,
            double.tryParse(bookingDataModel!.data.startCoordinate.split(",").last) ?? 0.0,);
          final destLatLng = LatLng(
            double.tryParse(bookingDataModel!.data.endCoordinate.split(",").first) ?? 0.0,
            double.tryParse(bookingDataModel!.data.endCoordinate.split(",").last) ?? 0.0,
          );
          updateOriginAndDestinationLatLong(origin: oriLatLng, destination: destLatLng);
        }

        notifyListeners();
      }

      /// *************** DRIVER UPDATED LAT LONG ********* -------

      else if (response['type'] == 'UpdatedLatLong') {
        log(response['type']);
        log("****************************      DRIVER UPDATED THE LAT LNG *************************");
        driverUpdatedPositionModel = DriverUpdatedPositionModel.fromJson(response);
        updateDriverLatLng(driverLtLng: LatLng(driverUpdatedPositionModel!.latitude, driverUpdatedPositionModel!.latitude));
        session.setDriverLatLong = "${driverUpdatedPositionModel!.latitude},${driverUpdatedPositionModel!.longitude}";
        updateBearing(val: double.tryParse(driverUpdatedPositionModel!.bearing.toString())!,);
        if (driverUpdatedPositionModel!.status == 3 || driverUpdatedPositionModel!.status == 5) {
          updateIsWithDriver(val: true);
          isWithDriver = true;
        }
        if (session.isRunningOrder) {
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
        session.setOriginLat = double.parse(acceptResponseModel!.data.startCoordinate.split(',').first);
        session.setOriginLong = double.parse(acceptResponseModel!.data.startCoordinate.split(',').last);
        session.setDestinationLat = double.parse(acceptResponseModel!.data.endCoordinate.split(',').first);
        session.setDestinationLong = double.parse(acceptResponseModel!.data.endCoordinate.split(',').last);
        updateIsWithDriver(val: false);
        isWithDriver = false;
        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** DEPARTURE TO CUSTOMER ********* -------
      else if (response['type'] == 'DepartToCustomer') {
        log("****************************     DRIVER DEPARTURE TO CUSTOMER *************************");
        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id.toString();
        session.setOrderStatus = 2;
        currentOrderStatus = 2;
        updateCurrentOrderStatus(val: 2);

        session.setDriverId = acceptResponseModel!.data.driverId.toString();
        updateIsWithDriver(val: false);
        isWithDriver = false;

        session.setIsRunningOrder = true;

        currentOrderStatus = 2;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** REACH TO CUSTOMER LOCATION  ********* -------
      else if (response['type'] == 'reachLocation') {
        log("****************************      DRIVER REACH YOUR LOCATION *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id.toString();
        session.setOrderStatus = 3;
        session.setDriverId = acceptResponseModel!.data.driverId.toString();
        updateIsWithDriver(val: true);
        isWithDriver = true;
        session.setIsRunningOrder = true;

        currentOrderStatus = 3;
        updateCurrentOrderStatus(val: 3);

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** START TRIP  ********* -------

      else if (response['type'] == 'startTrip') {
        log("****************************      DRIVER START THE RIDE *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id.toString();
        session.setOrderStatus = 5;
        session.setDriverId = acceptResponseModel!.data.driverId.toString();
        updateIsWithDriver(val: true);
        isWithDriver = true;

        currentOrderStatus = 5;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** END TRIP  ********* -------

      else if (response['type'] == 'endTrip') {
        log("****************************      DRIVER END THE RIDE *************************");
        session.setOrderStatus = 7;
        currentOrderStatus = 7;
        updateCurrentOrderStatus(val: 7);
        print(response);
        updateReceiptResponseModel(ReceiptResponseModel.fromJson(response));
        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id.toString();
        saveOrderReceipt();
        notifyListeners();
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
          showDialog(
            barrierDismissible: false,
            context: locator<GlobalKey<NavigatorState>>().currentContext!,
            builder: (BuildContext context) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
                  title: Text("Ride is Cancelled by the Driver"),
                  // content: new Text("sdf"),
                  actions: [
                    // usually buttons at the bottom of the dialog
                    ElevatedButton(
                      child: Text("Find Next Driver"),
                      onPressed: () async {
                        session.setIsRunningOrder = false;
                        _homeProvider.clearState();
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
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
          addChatAll(
            List<ChatModel>.from(
              response["data"].map(
                (x) => ChatModel.fromMap(x),
              ),
            ),
          );
          // dismissLoading();
          log("chat data is :-->>${chatMessageList.length}");
          print("chat data is :-->>${chatMessageList.length}");
        } else {
          addChatAll([]);
          // dismissLoading();
        }
      }

      else if (response['type'] == 'Chat') {
        addSingleChat(
          ChatModel.fromMap(
            response['data'],
          ),
        );

        log("chat data is :-->>${chatMessageList.length}");
      }
      else  if (response['type'] == 'UnreadCount') {
        log("unread message count called");

        updateUnReadMessages(count: response['data']);
      }
    });
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

    // var latDriver driverLatLng.
    MarkerId markerId = const MarkerId("driver");

    // creating a new MARKER
    final Marker marker = Marker(
      anchor: const Offset(0.5, 0.5),
      markerId: markerId,
      position: LatLng(latDriver, lngDriver),
      icon: driverMarker,
      // rotation: bearing - 30,
      // infoWindow: InfoWindow(title: "${latDriver},${lngDriver}"),
      onTap: () {},
    );

    markers[markerId] = marker;
    if (listenLocation && session.isRunningOrder) {
      logMe("is with driver called:-->> ${isWithDriver}");
      if ((isWithDriver) ||
          (currentOrderStatus == 5) ||
          (currentOrderStatus == 7) ||
          (currentOrderStatus == 3)) {
        log("driver:-  is with driver. $isWithDriver");
        log("driver:- destination LatLng. $destinationLatLng");
        await setPolyLinesDirection(
            LatLng(latDriver, lngDriver), destinationLatLng);
      } else {
        log("driver:-  is not with driver. $isWithDriver");
        log("driver:-  is not with driver.origin lat long $originLatLng");
        await setPolyLinesDirection(LatLng(latDriver, lngDriver), originLatLng);
      }
    }
    await animateToLocation(LatLng(latDriver, lngDriver));
  }

  // Save UserData to SharedPreferences
  void saveOrderReceipt() {
    session.setIsPaymentDone = false;
    session.setIsRatingGiven = false;
    logMe("save order receipt called");

    if (receiptResponseModel != null) {
      logMe("save order receipt called receiptResponseModel ==== NOT NULL");

      session.setOrderReceipt = json.encode(receiptResponseModel!);
      // _prefs.setString(_userDataKey, jsonEncode(_userData!.toMap()));
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

  Future<void> setPolyLinesDirection(LatLng origin, LatLng destination) async {
    log("polyline///  --Driver co:" + origin.latitude.toString() + "," + origin.longitude.toString());
    log("polyline/// destination co:" + destination.latitude.toString() + "," + destination.longitude.toString());
    await DirectionHelper().getRouteBetweenCoordinates(origin.latitude, origin.longitude, destination.latitude, destination.longitude).then((result) {
      log("Polyline results are ::::::::--------------  ${result} ------------********");
      if (result.isNotEmpty) {
        polylineCoordinates = [];
        for (var point in result) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        Polyline polyline = Polyline(
            polylineId: const PolylineId("jalur"),
            color: Colors.black,
            points: polylineCoordinates,
            width: 6,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap);

        polylines.clear(); // Clearing polylines is not necessary here
        polylines.add(polyline);
        log("Polylines are:-->> " + polylines.toString());
      }
      notifyListeners();
    });
  }

//   /** Send RIDE REQUEST to Drivers **/

  Future<bool> createRideRequest({
    required originLatLng,
    required destinationLatLng,
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
        'vehicle_category_id': vehicleCatagory,
        'start_coordinate': originLatLng,
        'end_coordinate': destinationLatLng,
        'start_address': startAddress,
        'end_address': endAddress,
        'estimated_time': estimatedTime,
        'distance': distance,
        'total': total,
        'payment_method': payment_method,
      };

      try {
        log("connection status :-->>${_socket!.connection.state}");
        // _socket!.connection.listen((event) {
        // if (event is Connected) {
        _socket!.send(json.encode(map));
        print("UserBookDriver ===========>>> ${map.toString()}");
        logMe(' CONNECTED:-->> Send New ride request -- > ${map.toString()}');
        notifyListeners();
        return true;

        // }
        // });
      } catch (e) {
        print(e.toString());
        return false;
      }

      // _socket!.send(jsonEncode(map));
    } catch (e) {
      print('Error creating ride request: $e');
      return false;
    }
  }

  //   /** -------------------*************************** CANCEL RIDE BY CUSTOMER  ******************----------------- */

  Future<bool> cancelRideByCustomer() async {
    try {
      final map = {
        'serviceType': 'CancelByUser',
        'UserID': session.userId,
        'OrderID': session.orderId
      };
      logMe('cancelRideByCustomer -- > ${map.toString()}');
      print('cancelRideByCustomer -- > ${map.toString()}');

      _socket!.send(jsonEncode(map));
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

    if (_socket!.connection.state is Connected) {
      log("socket is connected ==>>unread count ");
      log("get total count:" + map.toString());
      _socket!.send(jsonEncode(map));
    } else {
      log("socket is connected ${_socket!.connection.state}");
    }
  }

//   /** Get Order Details */
  Future<OrderDetailResponseModel> fetchOrderDetails(int id) async {
    log("fetch order details called");
    final String apiUrl =
        'https://api.gatsbyrideshare.com/api/webservice/getOrder?id=$id';

    try {
      log("try called : ${apiUrl}");
      final response = await Dio().get(apiUrl);
      log("--------******* ${response.data}");

      if (response.statusCode == 200) {
        dismissLoading();
        log("--------******* ${response.data}");

        log("response is :${response}");
        // If the server returns a 200 OK response, parse the JSON
        OrderDetailResponseModel data =
            OrderDetailResponseModel.fromJson(response.data);
        updateReceiptResponseModel(ReceiptResponseModel.fromJson(response.data),
            addData: true);
        session.setOrderStatus = int.parse(data.data.orderStatus.toString());

        return data;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle network or decoding errors
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

//   /** Get DRIVER Details */
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
        // If the server returns a 200 OK response, parse the JSON
        DriverDetailResponseModel data =
            DriverDetailResponseModel.fromJson(response.data);
        return data;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle network or decoding errors
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<void> updateOnlyBitmap() async {
    await getBytesFromAsset(initialPickUpIcon, 300).then((value) async {
      pickUpMarker = BitmapDescriptor.fromBytes(value);
    });
    await getBytesFromAsset(destinationIcon, 100).then((value) async {
      destinationMarker = BitmapDescriptor.fromBytes(value);
    });
    await getBytesFromAsset(carIconAsset, 150).then((value) {
      driverMarker = BitmapDescriptor.fromBytes(value);
    });

    await getBytesFromAsset(initialPickUpIcon, 300).then((value) {
      initialMarker = BitmapDescriptor.fromBytes(value);
    });
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
    print("connection state ${_socket!.connection.state}");
    log('-----Event  ${_socket!.connection.state}');
    log('connection state  ${_socket!.connection.state}');

    log("join socket called $type");
    print("join socket called $type");

    if (type == 'Join') {
      isLoading = true;

      markMessageAsRead(receiverId: receiverId);
    } else if (type == 'unJoin') {
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

    _socket!.send(json.encode(map));
    notifyListeners();
  }

  void markMessageAsRead({
    int? receiverId,
  }) {
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
    _socket!.send(jsonEncode(map));
    // updateUnreadCount("0");
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
    // final chatProvider = locator<ChatProvider>();
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

    _socket!.send(jsonEncode(map));
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
        setAddressFromLatLng(orderDataDetail);
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
    final call = Uri.parse('tel:${orderDetailResponseModel?.data.phone ?? '9876543210'}');
    launchUrl(call);
  }

  void setAddressFromLatLng(OrderDataDetail orderDataDetail) async {
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
        icon: await getBytesFromAsset(initialPickUpIcon, 300).then((value) {
          return initialMarker = BitmapDescriptor.fromBytes(value);
        }),
        onTap: () {},
      );
      final Marker markerDestination = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: markerIdDestination,
        position: LatLng(orderDataDetail.destinationLatLng.latitude,
            orderDataDetail.destinationLatLng.longitude),
        infoWindow: const InfoWindow(title: "destination"),
        icon: await getBytesFromAsset(destinationIcon, 100).then((value) {
          return destinationMarker = BitmapDescriptor.fromBytes(value);
        }),
        onTap: () {},
      );

      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
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
    await getBytesFromAsset(initialPickUpIcon, 300).then((value) async {
      pickUpMarker = BitmapDescriptor.fromBytes(value);
    });
    await getBytesFromAsset(destinationIcon, 100).then((value) async {
      destinationMarker = BitmapDescriptor.fromBytes(value);
    });
    await getBytesFromAsset(carIconAsset, 150).then((value) {
      driverMarker = BitmapDescriptor.fromBytes(value);
    });

    await getBytesFromAsset(initialPickUpIcon, 300).then((value) {
      initialMarker = BitmapDescriptor.fromBytes(value);
    });
  }

  void updateOriginAndDestinationLatLong({required LatLng origin, required LatLng destination}) {
    originLatLng = origin;
    destinationLatLng = destination;
    notifyListeners();
  }

  Future<void> moveCameraToDriver() async {
    await animateToLocation(LatLng(_driverLat, _driverLng));
  }
}
