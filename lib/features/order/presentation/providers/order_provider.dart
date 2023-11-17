import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:GetsbyRideshare/core/domain/entities/order_data_detail.dart';
import 'package:GetsbyRideshare/core/static/assets.dart';
import 'package:GetsbyRideshare/core/static/enums.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/order/data/models/chat_response_modal.dart';
import 'package:GetsbyRideshare/features/order/domain/entities/driver_detail.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/get_driver_detail.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/get_driver_location.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/get_order_detail.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/get_receipt.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/get_status_order.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/submit_ratings.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/update_status_order.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/get_driver_detail_state.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/get_driver_location_state.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/get_order_detail_state.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/get_receipt_state.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/get_status_order_state.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/submit_ratings_state.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/update_status_order_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lctn;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utility/direction_helper.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../../data/models/driver_location_response_model.dart';

class OrderProvider with ChangeNotifier {
  //Constructor
  final UpdateStatusOrder updateStatusOrder;
  final GetStatusOrder getStatusOrder;
  final GetOrderDetail getOrderDetail;
  final GetDriverDetail getDriverDetail;
  final GetDriverLocation getDriverLocation;
  final SubmitRatings submitRatings;
  final GetOrderReceipt orderReceipt;

  //Initial
  final lctn.Location locationService = lctn.Location();
  // CameraPosition kJapanCoordinate = const CameraPosition(
  //   target: JAPAN_LATLNG,
  //   zoom: 14.4746,
  // );

  //Web Socket

  // WebSocket? _socket;

  List<ChatData> chatMessages = [];

  DriverLocationResponseModel? _driverLocation;
  DriverDetail? _driverDetail;
  double _driverLat = 0.0;
  double _driverLng = 0.0;

  late GoogleMapController googleMapController;
  OrderStatus _orderStatus = OrderStatus.lookingDriver;
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
  final session = locator<Session>();

  String orderId = '';

  double ratingGiven = 10.0;
  String commentGiven = '';

  bool isOrderAccepted = false;

  TextEditingController commentsEditingController = TextEditingController();

  double lat = 0.0;
  double long = 0.0;

  // int unreadMessage = 0;

/** Driver Details */
  String driverName = '';
  String ratings = '';
  String carModal = '';
  String plateNumber = '';
  String phoneNumber = '';
  String driverId = '';
  String driverImg = '';
  String driverStatus = "Fetching Driver";

  bool isReachedToDestination = false;

//update Driver Details
  updateDriverDetails({required DriverDetail data}) {
    log(data.toString());
    driverName = data.name;
    ratings = data.rating.toString();
    carModal = data.model;
    plateNumber = data.plat;
    phoneNumber = data.phone;
    driverId = data.id.toString();
    driverImg = data.image != null ? data.image! : '';

    updateDriverStatus(session.orderStatus == 1
        ? "Driver is arriving"
        : session.orderStatus == 2
            ? appLoc.yourDriverIsOnTheWay
            : session.orderStatus == 3
                ? appLoc.driverReachYourLocation
                : session.orderStatus == 5
                    ? appLoc.departToDestination
                    : session.orderStatus == 6
                        ? appLoc.arriveAtDestination
                        : appLoc.complete);

    log("update driver status called");

    notifyListeners();
  }

  bool isCanceledByDriver = true;

  updateCanceledBy({required bool isDriver}) {
    isCanceledByDriver = isDriver;
    notifyListeners();
  }

  // updateUnReadMessages({required bool isNewMessage}) {
  //   log("update unread message called");
  //   if (isNewMessage) {
  //     unreadMessage = unreadMessage + 1;
  //     notifyListeners();
  //   } else {
  //     unreadMessage = 0;
  //   }
  //   notifyListeners();

  //   log("new message count is : ${unreadMessage}");
  // }

  //Update driver status
  updateDriverStatus(value) {
    // if ((session.orderStatus == 3) ||
    //     (session.orderStatus == 5) ||
    //     (session.orderStatus == 6) ||
    //     (session.orderStatus == 4)) {
    //   isWithDriver = true;
    // }
    // if ((value == appLoc.driverReachYourLocation) ||
    //     value == appLoc.departToDestination) {
    //   isWithDriver = true;
    // }
    driverStatus = value;
    notifyListeners();

    log("update driver status called is with driver-->> $isWithDriver");
  }

  //get
  OrderStatus get orderStatus => _orderStatus;
  DriverLocationResponseModel? get driverLocation => _driverLocation;
  DriverDetail? get driverDetail => _driverDetail;
  double get driverLat => _driverLat;
  double? get driverLng => _driverLng;

  //setter
  set changeOrderStatus(val) {
    _orderStatus = val;

    notifyListeners();
  }

  set changeFirstTracking(val) {
    isFirstTracking = val;
    notifyListeners();
  }

  //Update Order ID
  updateOrderId(value) {
    orderId = session.orderId;
    notifyListeners();
  }

  updateOrderAccepted() {
    isOrderAccepted = true;
    notifyListeners();
  }

// Update isReachedToDestination

  updateReachedDestination() {
    isReachedToDestination = true;
    notifyListeners();
  }

  //updat LatLong initially
  updateLatLong({required double latitude, required double longitude}) {
    lat = latitude;

    long = longitude;
    notifyListeners();
  }

// Update rating and comments
  updateRatingComment({double? rating, String? comment}) {
    ratingGiven = rating!;
    commentGiven = comment!;
    notifyListeners();
  }

  //constructor
  OrderProvider({
    required this.updateStatusOrder,
    required this.getStatusOrder,
    required this.getDriverDetail,
    required this.getOrderDetail,
    required this.getDriverLocation,
    required this.submitRatings,
    required this.orderReceipt,
  }) {
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

    updateLatLong(
      latitude: double.parse(session.currentLat),
      longitude: double.parse(session.currentLong),
    );
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
        zoom: 18,
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
    _orderStatus = OrderStatus.lookingDriver;

    notifyListeners();
  }

//Call Driver
  callDriver() async {
    final call = Uri.parse('tel:${_driverDetail!.phone}');
    launchUrl(call);
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
        for (var point in result) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        Polyline polyline = Polyline(
            polylineId: const PolylineId("jalur"),
            color: Colors.lightBlue,
            points: polylineCoordinates,
            width: 6,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap);
        polylines.add(polyline);

        log(polylines.toString());
        notifyListeners();
      }
    });
  }

//Update Order Status from User side
  Stream<UpdateStatusOrderState> submitStatusOrder(int orderStatus) async* {
    yield UpdateStatusOrderLoading();
    final formData = FormData.fromMap({
      'id': session.orderId,
      'status': orderStatus.toString(),
    });
    final result = await updateStatusOrder.execute(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield UpdateStatusOrderFailure(failure: failure);
    }, (data) async* {
      yield UpdateStatusOrderLoaded(data: data);
    });
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
    final result = await submitRatings.execute(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield SubmitRatingsFailure(failure: failure);
    }, (data) async* {
      yield SubmitRatingsLoaded(data: data);
    });
  }

  updateIsWithDriver() {
    log("update is with driver called");
    if ((session.orderStatus == 3) ||
        (session.orderStatus == 4) ||
        (session.orderStatus == 5) ||
        (session.orderStatus == 6)) {
      isWithDriver = true;
      notifyListeners();
    }
  }

  //Order Receipt
  Stream<GetReceiptState> orderReceiptApi() async* {
    log("estimated distance :-->> ${session.estimatedDistance}");
    log("estimated time :-->> ${session.estimatedTime}");

    yield GetReceiptLoading();
    final formData = FormData.fromMap({
      "id": session.orderId,
      // "distance": (int.parse(session.estimatedDistance) / 1000),
      // "time": (int.parse(session.estimatedTime) / 60).round()
    });
    log("form data of order is --->> $formData");
    final result = await orderReceipt.execute(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield GetReceiptFailure(failure: failure);
    }, (result) async* {
      yield GetReceiptLoaded(data: result);
    });
    updateReachedDestination();
    notifyListeners();
  }

/** Get Order Status */
  Stream<GetStatusOrderState> fetchOrderStatus() async* {
    yield GetStatusOrderLoading();

    final result = await getStatusOrder.call();
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield GetStatusOrderFailure(failure: failure);
    }, (data) async* {
      yield GetStatusOrderLoaded(data: data);
    });
  }

/** Get Order Details */
  Stream<GetOrderDetailState> fetchOrderDetail() async* {
    yield GetOrderDetailLoading();

    final result = await getOrderDetail.call();
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield GetOrderDetailFailure(failure: failure);
    }, (data) async* {
      session.setDriverId = data.driverId.toString();
      yield GetOrderDetailLoaded(data: data);
    });
  }

/**  Get Driver Details */
  Stream<GetDriverDetailState> fetchDriverDetail() async* {
    yield GetDriverDetailLoading();

    final result = await getDriverDetail.call();
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield GetDriverDetailFailure(failure: failure);
    }, (data) async* {
      _driverDetail = data;
      yield GetDriverDetailLoaded(data: data);
    });
  }

  /**   OLD CODE */

  //   Stream<GetDriverLocationState> fetchDriverLocation() async* {
  //   yield GetDriverLocationLoading();

  //   final result = await getDriverLocation.call();
  //   yield* result.fold((failure) async* {
  //     logMe("failure");
  //     logMe(failure);
  //     yield GetDriverLocationFailure(failure: failure);
  //   }, (data) async* {
  //     var latLong = data.longLat;
  //     var split = latLong.split(",");
  //     var latDriver = double.parse(split[0]);
  //     var lngDriver = double.parse(split[1]);
  //     if (_driverLat != latDriver && _driverLng != lngDriver) {
  //       _driverLat = latDriver;
  //       _driverLng = lngDriver;
  //       _driverLocation = data;
  //       logMe("Listen True");
  //       await trackingDriver(true);
  //     } else {
  //       logMe("Listen False");
  //       await trackingDriver(false);
  //     }

  //     yield GetDriverLocationLoaded(data: data);
  //   });
  // }

/** Get Driver Location */
  Stream<GetDriverLocationState> fetchDriverLocation() async* {
    yield GetDriverLocationLoading();

    final result = await getDriverLocation.call();
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield GetDriverLocationFailure(failure: failure);
    }, (data) async* {
      var latLong = data.longLat;
      var split = latLong.split(",");
      var latDriver = double.parse(split[0]);
      var lngDriver = double.parse(split[1]);

      log("fetchDriverLocation:-->> _driverLat ${_driverLat} ");
      log("fetchDriverLocation:-->> latDriver ${latDriver} ");
      log("fetchDriverLocation:-->> _driverLng ${_driverLng} ");
      log("fetchDriverLocation:-->> lngDriver ${lngDriver} ");

      if (_driverLat != latDriver && _driverLng != lngDriver) {
        _driverLat = latDriver;
        _driverLng = lngDriver;
        _driverLocation = data;
        logMe("Listen True");
        await trackingDriver(true);
      } else {
        logMe("Listen False");
        await trackingDriver(false);
      }

      yield GetDriverLocationLoaded(data: data);
    });
  }

  moveCameraToDriver() {
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_driverLat, _driverLng),
      zoom: 18,
    )));
  }

/**  Tracking Driver */
  trackingDriver(bool listenLocation) async {
    updateIsWithDriver();
    log(" driver:- tracking driver called-->>>>>.");
    log("driver:- is listenLocation :$listenLocation");
    var latLong = _driverLocation!.longLat;
    var split = latLong.split(",");
    var bearing = _driverLocation!.bearing;
    var latDriver = double.parse(split[0]);
    var lngDriver = double.parse(split[1]);
    MarkerId markerId = const MarkerId("driver");

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latDriver, lngDriver),
      icon: driverMarker,
      rotation: bearing.toDouble(),
      onTap: () {},
    );
    //add to marker list
    markers[markerId] = marker;

    if (isFirstTracking) {
      if (listenLocation) {
        logMe("session.driverLat $_driverLng");
        logMe("session.driverLng $_driverLat");
        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(latDriver, lngDriver),
          zoom: 18,
        )));
      }
    } else {
      if (listenLocation) {
        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(latDriver, lngDriver),
          zoom: 18,
        )));

        if (isWithDriver) {
          log("driver:-  is with driver. $isWithDriver");
          setPolylinesDirection(
              LatLng(latDriver, lngDriver), destinationLatLng);
        } else {
          log("driver:-  is not with driver. $isWithDriver");

          setPolylinesDirection(LatLng(latDriver, lngDriver), originLatLng);
        }
      }
    }

    notifyListeners();
  }

  // Web Socket Client

  //  connectToSocket() {
  //   logMe('============= Chat Token ${session.chatToken} ================');
  //   _socket = WebSocket(Uri.parse(
  //       'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.driverId}'));

  //   logMe('============= Connecting to Socket ================');
  //   _socket!.connection.listen((event) {
  //     logMe('Socket on Listen ---> ${event.toString()}');
  //     if (event is Connected) {
  //       listenRequests();
  //     }
  //   });
  // }
}
