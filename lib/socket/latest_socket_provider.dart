import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:GetsbyRideshare/core/presentation/pages/home_page/home_page.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:GetsbyRideshare/socket/modals/accept_response_model.dart';
import 'package:GetsbyRideshare/socket/modals/driver_updated_position_model.dart';
import 'package:GetsbyRideshare/socket/modals/order_status_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:location/location.dart' as lctn;
import '../core/domain/entities/order_data_detail.dart';
import '../core/presentation/providers/home_provider.dart';
import '../core/static/assets.dart';
import '../core/utility/direction_helper.dart';
import '../core/utility/helper.dart';
import '../core/utility/injection.dart';
import '../features/order/data/models/chat_modal.dart';
import '../features/order/domain/entities/driver_detail.dart';
import '../features/order/presentation/pages/components/new_receipt_model.dart';
import '../features/order/presentation/providers/get_receipt_state.dart';
import '../features/order/presentation/providers/submit_ratings_state.dart';
import 'modals/booking_response_model.dart';

class LatestSocketProvider extends ChangeNotifier {
  static final LatestSocketProvider _provider = LatestSocketProvider.internal();

  factory LatestSocketProvider() {
    return _provider;
  }

  LatestSocketProvider.internal();
  final session = locator<Session>();
  var _homeProvider = locator<HomeProvider>();

  final lctn.Location locationService = lctn.Location();
  late StreamSubscription<Position>? locationbackSubscription;
  // CameraPosition kJapanCoordinate = const CameraPosition(
  //   target: JAPAN_LATLNG,
  //   zoom: 14.4746,
  // );
  var unreadCount = '0';
  final chatController = TextEditingController();
  BuildContext currentCxt =
      locator<GlobalKey<NavigatorState>>().currentContext!;

  List<ChatModel> _chatMessagesList = [];
  int currentOrderStatus = 0;

  bool isOrderAccepted = false;

  updateIsOrderAccepted({required bool val}) {
    isOrderAccepted = val;
    notifyListeners();
  }

  int unreadMessageCount = 0;
  bool isLoading = false;
  BookingDataModel? bookingDataModel;
  AcceptResponseModel? acceptResponseModel;
  DriverUpdatedPositionModel? driverUpdatedPositionModel;

  List<ChatModel> get chatMessageList => _chatMessagesList;
  OrderStatusResponseModel? orderStatusResponseModel;

  updateUnreadCount(val) {
    unreadCount = val;
    notifyListeners();

    log("unrad count :-->> $unreadCount");
  }

  DriverDetail? _driverDetail;
  DriverDetail? get driverDetail => _driverDetail;

  // DriverLocationResponseModel? _driverLocation;

  double _driverLat = 0.0;
  double _driverLng = 0.0;

  late GoogleMapController googleMapController;
  // OrderStatus _orderStatus = OrderStatus.lookingDriver;
  late LatLng originLatLng, destinationLatLng;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor pickUpMarker, destinationMarker, initialMarker;
  String originAddress = '';
  bool isFirstTracking = true;
  bool isWithDriver = false;
  String destinationAddress = "Destination";
  late Text originText;
  late Text destinationText;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  ReceiptData? receiptData;

  String orderId = '';

  double ratingGiven = 1;
  double zoom = 15;

  String commentGiven = '';

  TextEditingController commentsEditingController = TextEditingController();

  updateBitsImage() {
    getBytesFromAsset(initialPickUpIcon, 300).then((value) async {
      pickUpMarker = BitmapDescriptor.fromBytes(value);
    });
    getBytesFromAsset(destinationIcon, 100).then((value) async {
      destinationMarker = BitmapDescriptor.fromBytes(value);
    });
    getBytesFromAsset(carIconAsset, 90).then((value) {
      driverMarker = BitmapDescriptor.fromBytes(value);
    });

    getBytesFromAsset(initialPickUpIcon, 300).then((value) {
      initialMarker = BitmapDescriptor.fromBytes(value);
    });
  }

  //
  WebSocket? _socket;

  // -----> function to connect the socket <--------- //
  Future<dynamic> connectToSocket(BuildContext context) async {
    log("-------->CONNECTING TO SOCKET <--------");
    log('-------> uri === ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
    _socket = WebSocket(
        Uri.parse(
          "ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}",
        ),
        backoff: ConstantBackoff(Duration(seconds: 5)));
    _socket!.connection.listen((event) {
      if (event is Connected) {
        log("************ Connectd ***********");
        print("************ Connectd ***********");

        listenSocketRequests(context);
      } else if (event is Connecting) {
        log("************ Connecting ***********");
        print("************ Connecting ***********");
      } else if (event is Disconnected) {
        log("************ DisConnectd ***********");
      } else if (event is Reconnecting) {
        log("************ ReConnecting ***********");
      } else if (event is Reconnected) {
        listenSocketRequests(context);
      } else {
        log("-----******** EVENT IS **** ${event}");
        print("-----******** EVENT IS **** ${event}");
      }
    });
  }

  Future<void> disconnectSocket() async {
    _socket!.close();
  }

  joinExitRoom({int? receiverId, required String type}) {
    markMessageAsRead(receiverId: receiverId);
    log("join socket called $type");
    if (type == 'Join') {
      isLoading = true;
      notifyListeners();
    } else if (type == 'unJoin') {
      getTotalUnreadCount(receiverId);
      // clearChatList();
    }
    // if (type == 'join') {
    //   markMessageAsRead(receiverId: receiverId);
    // }
    final map = {
      'type': 'Customer',
      'serviceType': type,
      'UserID': session.userId,
      'roomID': (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
    };
    logMe('Join Exit room socket -- > ${map.toString()}');

    try {
      _socket!.connection.listen((event) {
        if (event is Connected) {
          _socket!.send(json.encode(map));
          print(map.toString());

          notifyListeners();
        }
      });
    } catch (e) {
      print(e.toString());
    }

    _socket!.send(
      jsonEncode(map),
    );
    // listenRequests();
  }

  void listenSocketRequests(BuildContext context) {
    _socket!.messages.listen((event) async {
      //  Decoding data
      final response = jsonDecode(event);
      log('-----Event  ${response.toString()}');

      // <----------- Checking When request come ---------> //
      if (response['type'] == 'CustomerBookRequest') {
        bookingDataModel = BookingDataModel.fromJson(response);
        // bookingList.add(bookingDataModel!.data);

        log("order id is :--->> ${bookingDataModel!.data.id} and Customer Id  is:--->> ${bookingDataModel!.data.customerId}");
        print(
            "order id is :--->> ${bookingDataModel!.data.id} and Customer Id  is:--->> ${bookingDataModel!.data.customerId}");

        if (bookingDataModel!.data.customerId == session.userId) {
          session.setOrderId = bookingDataModel!.data.id;
        }

        notifyListeners();
      }

      /// *************** DRIVER UPDATED LAT LONG ********* -------

      if (response['type'] == 'UpdatedLatLong') {
        log(response['type']);
        log("****************************      DRIVER UPDATED THE LAT LNG *************************");
        driverUpdatedPositionModel =
            DriverUpdatedPositionModel.fromJson(response);
        notifyListeners();
        // session.setOrderId = acceptResponseModel!.data.id;
        // session.setDriverId = acceptResponseModel!.data.driverId;
        session.setOrderStatus = 1;
        // currentOrderStatus = 1;
        await trackingDriver(
            listenLocation: true,
            lat: driverUpdatedPositionModel!.latitude,
            long: driverUpdatedPositionModel!.longitude);

        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** RIDE ACCEPTED ********* -------

      if (response['type'] == 'Accept') {
        log("****************************      DRIVER ACCEPTED THE RIDE *************************");
        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setDriverId = acceptResponseModel!.data.driverId;
        updateIsOrderAccepted(val: true);
        session.setOrderStatus = 1;
        currentOrderStatus = 1;
        updateIsWithDriver(val: false);

        notifyListeners();

        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** DEPARTURE TO CUSTOMER ********* -------
      if (response['type'] == 'DepartToCustomer') {
        log("****************************      DRIVER DEPARTURE TO CUSTOMER *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setOrderStatus = 2;
        session.setDriverId = acceptResponseModel!.data.driverId;
        updateIsWithDriver(val: false);

        currentOrderStatus = 2;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** REACH TO CUSTOMER LOCATION  ********* -------
      if (response['type'] == 'reachLocation') {
        log("****************************      DRIVER REACH YOUR LOCATION *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setOrderStatus = 3;
        session.setDriverId = acceptResponseModel!.data.driverId;
        updateIsWithDriver(val: true);

        currentOrderStatus = 3;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** START TRIP  ********* -------

      if (response['type'] == 'startTrip') {
        log("****************************      DRIVER START THE RIDE *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setOrderStatus = 5;
        session.setDriverId = acceptResponseModel!.data.driverId;
        updateIsWithDriver(val: true);

        currentOrderStatus = 5;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** END TRIP  ********* -------

      if (response['type'] == 'endTrip') {
        log("****************************      DRIVER END THE RIDE *************************");

        acceptResponseModel = AcceptResponseModel.fromJson(response);
        receiptData = ReceiptData.fromJson(response);
        session.setOrderId = acceptResponseModel!.data.id;
        session.setOrderStatus = 7;
        currentOrderStatus = 7;

        notifyListeners();
        log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
      }

      /// *************** DRIVER CANCEL THE RIDE  ********* -------

      if (response['type'] == 'Reject') {
        log("****************************      DRIVER CANCEL THE RIDE *************************");

        if (response["data"]["driverID"] != null) {
          acceptResponseModel = AcceptResponseModel.fromJson(response);
          session.setOrderId = acceptResponseModel!.data.id;
          session.setOrderStatus = 8;
          currentOrderStatus = 8;

          notifyListeners();
          showDialog(
            context: currentCxt,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("Ride is Cancelled by the Driver"),
                // content: new Text("sdf"),
                actions: [
                  // usually buttons at the bottom of the dialog
                  ElevatedButton(
                    child: Text("Find Next Driver"),
                    onPressed: () async {
                      await _homeProvider.clearState();

                      Navigator.pop(context);

                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);

                      // Navigator.of(currentCxt).pop();
                      // Navigator.pushAndRemoveUntil(
                      //     currentCxt,
                      //     MaterialPageRoute(
                      //       builder: (currentCxt) => HomePage(),
                      //     ),
                      //     (route) => false);
                    },
                  ),
                ],
              );
            },
          );
          log("-------->>>>>> ********* >>>>>>> CURRENT ORDER STATUS IS:-->> ${currentOrderStatus}   ----------<<<<<<<<<<<<*********");
        }
      }

      // <----------- Checking When request come ---------> //
      if (response['type'] == 'MessageList') {
        isLoading = false;
        notifyListeners();
        log("messgae type is MESSAGE LIST");
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
        } else {
          addChatAll([]);
          // dismissLoading();
        }
      }
      if (response['type'] == 'Chat') {
        addSingleChat(
          ChatModel.fromMap(
            response['data'],
          ),
        );

        log("chat data is :-->>${chatMessageList.length}");
      }
      if (response['type'] == 'UnreadCount') {
        log("unread message count called");

        updateUnReadMessages(count: response['data']);
      }

      log('-----Event  ${response.toString()}');
    });
  }

  addChatAll(List<ChatModel> list) {
    _chatMessagesList = list;
    notifyListeners();
  }

  addSingleChat(ChatModel chat) {
    log("my single chat data is:-->> $chat");
    _chatMessagesList.insert(0, chat);
    notifyListeners();
  }

  updateUnReadMessages({required int count}) {
    unreadMessageCount = count;

    log("un read message count is:-->> $unreadMessageCount");
    notifyListeners();
  }

  sendChatMessage({
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

  //   //Get total number of unread message
  getTotalUnreadCount(int? receiverId) {
    log("get total count");
    final map = {
      "userID": session.userId,
      "serviceType": "UnreadCount",
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "UserType": 'Customer'
    };
    log("get total count:" + map.toString());
    _socket!.send(jsonEncode(map));

    // listenRequests();
    // disconnectSocket();
    // connectToSocket();
    // listenRequests();
  }

  markMessageAsRead({
    int? receiverId,
  }) {
    log("mark message as read  called");
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

    log("mark as read $map");
    _socket!.send(jsonEncode(map));
  }

  clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
  }

  rejectRequestSocket() {
    final map = {
      'serviceType': 'RejectRequest',
      'driverID': session.userId,
    };
    logMe('reject request socket -- > ${map.toString()}');
    _socket!.send(
      jsonEncode(map),
    );
  }

  acceptRequestSocket() {
    final map = {
      'serviceType': 'AcceptRequest',
      'driverID': session.userId,
    };
    logMe('reject request socket -- > ${map.toString()}');
    _socket!.send(jsonEncode(map));
  }

  /** Send RIDE REQUEST to Drivers **/

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
        _socket!.connection.listen((event) {
          if ((event is Connected) || (event is Reconnected)) {
            _socket!.send(json.encode(map));
            print(map.toString());

            logMe(
                ' CONNECTED:-->> Send New ride request -- > ${map.toString()}');

            notifyListeners();
          }
        });
      } catch (e) {
        print(e.toString());
      }

      logMe('Send New ride request -- > ${map.toString()}');
      // _socket!.send(jsonEncode(map));

      return true;
    } catch (e) {
      print('Error creating ride request: $e');
      return false;
    }
  }

  // Future<bool>createRideRequest({
  //   required originLatLng,
  //   required destinationLatLng,
  //   required vehicleCatagory,
  //   required startAddress,
  //   required endAddress,
  //   required estimatedTime,
  //   required distance,
  //   required total,
  //   required payment_method,
  // }) {
  //   final map = {
  //     'serviceType': 'UserBookDriver',
  //     'UserID': session.userId,
  //     'vehicle_category_id': vehicleCatagory,
  //     'start_coordinate': originLatLng,
  //     'end_coordinate': destinationLatLng,
  //     'start_address': startAddress,
  //     'end_address': endAddress,
  //     'estimated_time': estimatedTime,
  //     'distance': distance,
  //     'total': total,
  //     'payment_method': payment_method,
  //   };

  //   logMe('Send New ride request -- > ${map.toString()}');
  //   _socket!.send(jsonEncode(map));

  // }

  /// * UPDATE LAT LONG --------->>>>>..

  updateLatLng(double lat, double long) async {
    print("current latlong:${lat},${long}");

    final map = {
      'serviceType': 'UpdatedLatLong',
      'UserID': session.userId,
      'type': 'customer',
      'Latitude': lat,
      'Longitude': long,
      'OrderID': session.orderId
    };
    logMe('UPADTE LATLONG -- > ${map.toString()}');
    print('UPADTE LATLONG -- > ${map.toString()}');

    _socket!.send(jsonEncode(map));
  }

  /** -------------------*************************** CANCEL RIDE BY CUSTOMER  ******************----------------- */

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

      return true;
    } catch (e) {
      return false;
    }
  }

  ///**********  HANDLE GOOGLE MAPS AND ORDER PROVIDER DATA HERE */

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  setCurrentLocation(OrderDataDetail orderDataDetail) async {
    log("set current location called");
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

  setAddressFromLatLng(OrderDataDetail orderDataDetail) async {
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
        infoWindow: const InfoWindow(title: "Destination"),
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
      originText = Text(
        originAddress,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      );
      markers[markerIdOrigin] = markerOrigin;
      markers[markerIdDestination] = markerDestination;
      notifyListeners();
    } catch (e) {
      logMe(e);
    }
  }

  removeMarker() async {
    MarkerId markerDriver = const MarkerId("driver");
    MarkerId markerOrigin = const MarkerId("origin");
    markers.remove(markerOrigin);
    markers.remove(markerDriver);
    isWithDriver = true;
    polylines.clear();
    notifyListeners();
  }

  //clear state
  clearState() async {
    await sessionClearOrder();
    polylines.clear();
    markers.clear();
    isWithDriver = false;
    isFirstTracking = true;
    // _orderStatus = OrderStatus.lookingDriver;

    notifyListeners();
  }

  /** Driver Details */
  String driverName = '';
  String ratings = '';
  String carModal = '';
  String plateNumber = '';
  String phoneNumber = '';
  String driverId = '';
  String driverImg = '';
  String driverStatus = "Fetching Driver";

  double lat = 0.0;
  double long = 0.0;

//Call Driver
  callDriver() async {
    final call = Uri.parse('tel:${_driverDetail!.phone}');
    launchUrl(call);
  }

  set changeFirstTracking(val) {
    isFirstTracking = val;
    notifyListeners();
  }

// Set polylines Direction
  setPolylinesDirection(LatLng origin, LatLng destination) async {
    log("polyline :" + origin.latitude.toString());
    log("polyline :" + destination.latitude.toString());

    await DirectionHelper()
        .getRouteBetweenCoordinates(origin.latitude, origin.longitude,
            destination.latitude, destination.longitude)
        .then((result) {
      if (result.isNotEmpty) {
        polylineCoordinates = [];
        polylineCoordinates.clear();
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

        polylines.add(polyline);

        log("Polylines are:-->> " + polylines.toString());
        notifyListeners();
      }
    });
  }

  // // Update rating and comments
  updateRatingComment({double? rating, String? comment}) {
    ratingGiven = rating!;
    commentGiven = comment!;
    notifyListeners();
  }

  moveCameraToDriver() {
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_driverLat, _driverLng),
      zoom: zoom,
    )));
  }

//   //Order Receipt
  Stream<GetReceiptState> orderReceiptApi() async* {
    // log("estimated distance :-->> ${session.estimatedDistance}");
    // log("estimated time :-->> ${session.estimatedTime}");

    // yield GetReceiptLoading();
    // final formData = FormData.fromMap({
    //   "id": session.orderId,
    //   // "distance": (int.parse(session.estimatedDistance) / 1000),
    //   // "time": (int.parse(session.estimatedTime) / 60).round()
    // });
    // log("form data of order is --->> $formData");
    // final result = await orderReceipt.execute(formData);
    // yield* result.fold((failure) async* {
    //   logMe("failure");
    //   logMe(failure);
    //   yield GetReceiptFailure(failure: failure);
    // }, (result) async* {
    //   yield GetReceiptLoaded(data: result);
    // });
    // updateReachedDestination();
    // notifyListeners();
  }

  //Submit Ratings Review
  Stream<SubmitRatingsState> submitRatingsReview() async* {
    log(commentGiven.toString());
    log(ratingGiven.toString());

    yield SubmitRatingsLoading();
    final formData = FormData.fromMap({
      "id": driverId,
      "order_id": session.orderId,
      "rating": ratingGiven,
      "review": commentsEditingController.text,
      "type": 1
    });
    // final result = await submitRatings.execute(formData);
    // yield* result.fold((failure) async* {
    //   logMe("failure");
    //   logMe(failure);
    //   yield SubmitRatingsFailure(failure: failure);
    // }, (data) async* {
    //   yield SubmitRatingsLoaded(data: data);
    // });
  }

  updateIsWithDriver({required bool val}) {
    log("update is with driver called");
    // if ((session.orderStatus == 3) ||
    //     (session.orderStatus == 4) ||-----******** EVENT IS ****
    //     (session.orderStatus == 5) ||
    //     (session.orderStatus == 6) ||
    //     (currentOrderStatus == 3) ||
    //     (currentOrderStatus == 4) ||
    //     (currentOrderStatus == 5)) {
    isWithDriver = val;
    notifyListeners();
    // }
  }

  // /**  Tracking Driver */
  Future<void> trackingDriver(
      {required bool listenLocation,
      required double lat,
      required double long}) async {
    // updateIsWithDriver();
    log("driver:- tracking driver called-->>>>>. ${lat} ${long}");
    log("driver:- is listenLocation :$listenLocation");

    log("is first tracking :--------************------>>>.. $isFirstTracking");
    // var latLong = {driverLatLng};
    // var split = latLong.split(",");
    // var bearing = _driverLocation!.bearing;
    // var latDriver = double.parse(split[0]);
    // var lngDriver = double.parse(split[1]);

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
      rotation: 0.0,
      infoWindow: InfoWindow(title: "${latDriver},${lngDriver}"),
      onTap: () {},
    );
    //add to marker list
    markers[markerId] = marker;

    notifyListeners();

    // if (isFirstTracking) {
    //   if (listenLocation) {
    //     logMe("session.driverLat $_driverLng");
    //     logMe("session.driverLng $_driverLat");
    //     await googleMapController
    //         .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //       target: LatLng(latDriver, lngDriver),
    //       zoom: zoom,
    //     )));
    //   }
    // } else
    //  {
    if (listenLocation) {
      // await googleMapController
      //     .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //   target: LatLng(latDriver, lngDriver),
      //   zoom: zoom,
      // )));

      if (isWithDriver) {
        log("driver:-  is with driver. $isWithDriver");
        setPolylinesDirection(LatLng(latDriver, lngDriver), destinationLatLng);
      } else {
        log("driver:-  is not with driver. $isWithDriver");

        setPolylinesDirection(LatLng(latDriver, lngDriver), originLatLng);
      }
      // }
    }
  }
}
