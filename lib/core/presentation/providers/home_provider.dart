import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:GetsbyRideshare/core/domain/entities/vehicles_category.dart';
import 'package:GetsbyRideshare/core/domain/usecases/get_total_price.dart';
import 'package:GetsbyRideshare/core/presentation/providers/total_price_state.dart';
import 'package:GetsbyRideshare/core/presentation/providers/vehicle_category_state.dart';
import 'package:GetsbyRideshare/core/static/assets.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/static/enums.dart';
import 'package:GetsbyRideshare/core/utility/app_settings.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/create_oder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../data/models/google_route_response_modal.dart';
import '../../domain/entities/price_category.dart';
import '../../domain/usecases/get_price_category.dart';
import '../../domain/usecases/get_vehicle_catagory.dart';
import '../../static/order_status.dart';
import '../../utility/direction_helper.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';
import 'create_order_state.dart';

class HomeProvider with ChangeNotifier {
  var dio = Dio();
  //  var sessionToken = locator<Session>().sessionToken;
  //Constructor
  final GetTotalPrice getTotalPrice;
  final GetPriceCategory getPriceCategory;
  final CreateOrder createOrder;
  final GetVehiclesCategory getVehicleCatagory;

  TotalPriceState _stateLoadPrice = TotalPriceInitial();

  bool isDestinationSelected = false;

  //Toggle isDestination selected
  toggleIsDestinationSelected() {
    isDestinationSelected = true;
    notifyListeners();
  }



  String estimatedTimeToShow = '';

  Session session = locator<Session>();

  LatLng defaultLatLng = LatLng(55.170834, -118.794724);

//Socket

  WebSocket? socket;

  // //Connec to Socket
  // connectToSocket() {
  //   logMe(
  //       'Socket ============= chat Token : ${session.chatToken} ================');
  //   logMe(
  //       'Socket ============= User Id Token :  ${session.userId} ================');

  //   socket = WebSocket(Uri.parse(

  //       // 'ws://shakti.parastechnologies.in:8051?token=597011984&room=0&userID=1'
  //       'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}'));

  //   logMe('Socket ============= Connecting to Socket ================');
  //   socket!.connection.listen((event) {
  //     logMe('Socket on Listen ---> ${event.toString()}');

  //     if (event is Connected) {
  //       // listenRequests();
  //       // sendRequest();

  //       log("=====event======>>>>> " + event.toString());
  //     } else if (event is Disconnected) {
  //       log("Socket === Event is Disconnected ===");
  //       log("Socket === reason ${event.reason}");
  //     }
  //   });
  // }

  //send request to socket

  // sendRequest() {
  //   socket!
  //       // .send("serviceType: UserBookDriver, id: ${session.userId.toString()}");
  //       .send(jsonEncode({
  //     "serviceType": "UserBookDriver",
  //     "UserID": "${session.userId.toString()}"
  //   }));

  //   socket!.connection.listen((state) => print('state: "$state"'));

  //   log("send request");
  // }

  bool isAccepted = false;
  bool isMapLoading = true;

  updateTermsAccepted(value) {
    isAccepted = value;
    notifyListeners();
  }

  double lat = 55.170834;
  double long = -118.794724;

  late GoogleMapController googleMapController;
  // Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng originLatLng = LatLng(55.170834, -118.794724);
  LatLng destinationLatLng = LatLng(55.170834, -118.794724);
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor pickUpMarker, destinationMarker, initialPickMarker;
  String originAddress = 'Pickup Address';
  bool destinationIsFilled = false;
  bool originIsFilled = false;
  String destinationAddress = appLoc.destination;
  String distance = "1", price = "";
  int totalDistance = 0;
  double zoom = 15.4746;
  int estimatedTime = 1;
  String time = '';
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  static List<PriceCategory> _priceCategory = [];
  PriceCategory? _selectedCategory;
  PaymentMethod? _paymentMethod;

  int selectedVehicleIndex = -1;

  String selectedVehicleId = '';
  String isAvailable = '';

  List<VehiclesCategory> _vehiclesCategory = [];

  // getter
  List<PriceCategory> get priceCategory => _priceCategory;
  PriceCategory? get selectedCategory => _selectedCategory;
  PaymentMethod? get paymentMethod => _paymentMethod;
  TotalPriceState get stateLoadPrice => _stateLoadPrice;
  List<VehiclesCategory> get vehicleCategory => _vehiclesCategory;

  //setter
  set setSelectedCategory(val) {
    _selectedCategory = val;
    notifyListeners();
  }

  //Update Estimated Time
  updateEstimatedTime(val) {
    estimatedTime = val;
    notifyListeners();
  }
  //Update Estimated Time
  void updateMapLoaded() {
    isMapLoading = false;
    notifyListeners();
  }

  set setPaymentMethod(val) {
    _paymentMethod = val;

    notifyListeners();
    log("Selected Payment Method is========>>>${_paymentMethod}");
  }

  set newState(TotalPriceState state) {
    _stateLoadPrice = state;
    notifyListeners();
  }

  //clear state
  clearState(){
    polylines.clear();
    destinationIsFilled = false;
    distance = "0";
    totalDistance = 0;
    price = "";
    _paymentMethod =null;
    selectedVehicleId = "";
    _selectedCategory = null;
    markers.clear();
    selectedVehicleIndex = -1;
    originIsFilled = false;
    originAddress = 'Pickup Address';
    isDestinationSelected= false;
    notifyListeners();
  }

  //Clear google maps data when ride create

  clearOldRideData() {
    log("*********CLEAR PREVIOUS POLYLINE CALLED-------");
    polylines.clear();
    destinationIsFilled = false;
    markers.clear();
    destinationAddress = appLoc.destination;
    notifyListeners();
  }

  //Update Selected Vehicle Index
  updateSelectedVehicleIndex({index}) {
    selectedVehicleIndex = index;
    notifyListeners();
  }

  List carsImageList = [
    "assets/icons/economy_car.png",
    "assets/icons/xl_car.png",
    "assets/icons/tesla_car.png"
  ];

  List vehiclesDetailsList = [
    {
      "carImg": "assets/icons/economy_car.png",
      "minimunFare": "5.00",
      "baseFare": "1.70",
      "techFee": "3.00",
      "perKm": "1.30",
      "perMin": "0.30",
      "seat": "4"
    },
    {
      "carImg": "assets/icons/xl_car.png",
      "minimunFare": "10.00",
      "baseFare": "2.00",
      "techFee": "3.00",
      "perKm": "1.65",
      "perMin": "0.35",
      "seat": "4-6"
    },
    {
      "carImg": "assets/icons/tesla_car.png",
      "minimunFare": "10.00",
      "baseFare": "2.00",
      "techFee": "3.00",
      "perKm": "1.65",
      "perMin": "0.35",
      "seat": "4-6"
    }
  ];

  //constructor
  HomeProvider(
      {required this.getTotalPrice,
      required this.getPriceCategory,
      required this.createOrder,
      required this.getVehicleCatagory}) {
    getBytesFromAsset(driverMarkerIcon, 100).then((value) {
      driverMarker = BitmapDescriptor.bytes(value);
    });
    getBytesFromAsset(initialPickUpIcon, 100).then((value) async {
      pickUpMarker = BitmapDescriptor.bytes(value);
    });
    getBytesFromAsset(destinationIcon, 40).then((value) async {
      destinationMarker = BitmapDescriptor.bytes(value);
    });
    getBytesFromAsset(initialPickUpIcon,100).then((value) async {
      initialPickMarker = BitmapDescriptor.bytes(value);
    });

    final session = locator<Session>();

    log("session.currentLat is :${session.currentLat}");
    log("session.currentLong is :${session.currentLong}");

    if (session.currentLat != '') {
      updateLatLong(
        latitude: double.parse(session.currentLat),
        longitude: double.parse(session.currentLong),
      );
    }

    // connectToSocket();
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

  updateLatLong({required double latitude, required double longitude}) {
    lat = latitude;
    long = longitude;
    notifyListeners();
  }

  Future<void> setCurrentLocation() async {
    print("*********** GET Current Location******************* ");
    clearState();
    clearOldRideData();
    destinationAddress = '';
    originAddress = 'Pickup Address';
    destinationIsFilled = false;
    originIsFilled = false;
    try {
      final locationData = await DirectionHelper.getCurrentLocation();
      if (locationData != null) {
        logMe("${locationData.latitude} ${locationData.longitude}",name: "LOCATION DATA");
        originLatLng = LatLng(locationData.latitude, locationData.longitude);
        destinationLatLng = LatLng(locationData.latitude, locationData.longitude);
        await setAddressFromLatLng();
      } else {
        await setDefaultLocation();
      }
      isMapLoading =false;
      notifyListeners();
    }  catch (e) {
      SmartDialog.dismiss();
      await setDefaultLocation();
    }
    notifyListeners();
  }





  FutureOr<void> setDefaultLocation() async{
    originLatLng = defaultLatLng;
    destinationLatLng = defaultLatLng;
     await setAddressFromLatLng();
  }

  Future<void> setAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(originLatLng.latitude, originLatLng.longitude);
      if(p.isEmpty){
        await setDefaultLocation();
        return;
      }
      Placemark place = p.first;
      MarkerId markerId = const MarkerId("origin");
      final Marker marker = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: markerId,
        position: LatLng(originLatLng.latitude, originLatLng.longitude),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: initialPickMarker,
        onTap: () {},
      );
      originIsFilled = true;
      notifyListeners();
      await googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(originLatLng.latitude, originLatLng.longitude),
        zoom: zoom,
      )));

      originAddress = "${place.street}, ${place.subLocality}, ${place.locality}";
      destinationAddress = "${place.street}, ${place.subLocality}, ${place.locality}";
      markers[markerId] = marker;
      notifyListeners();
    } catch (e) {
      logMe(e);
    }
  }

// Show marker on Map according to latlong and addresstype
  displayResult(LatLng latlng, String address, AddressType addressType) async {
    final MarkerId markerId = MarkerId(addressType == AddressType.origin ? "origin" : "destination");
    try {
      final Marker marker = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: markerId,
        position: latlng,
        icon: addressType == AddressType.origin
            ? pickUpMarker
            : destinationMarker,
        onTap: () {},
      );

      if (addressType == AddressType.origin) {
        originAddress = address;
        originLatLng = latlng;

        originIsFilled = true;

        if (destinationIsFilled) {
          await setPolylinesDirection(originLatLng, destinationLatLng);
        }
      } else {
        destinationAddress = address;
        destinationLatLng = latlng;
        destinationIsFilled = true;
       await setPolylinesDirection(originLatLng, destinationLatLng);
      }
      markers[markerId] = marker;
      List<Marker> listMarker = [];
      markers.forEach((k, v) => listMarker.add(v));
      CameraUpdate cu = CameraUpdate.newLatLngBounds(getBounds(listMarker), 75);
      googleMapController.animateCamera(cu);
      notifyListeners();
    } catch (e) {
      logMe("error dislay ${e.toString()}");
    }
  }

  Future<void> setPolylinesDirection(LatLng origin, LatLng destination) async {
    polylines.clear();
    await DirectionHelper().getRouteBetweenCoordinates(origin.latitude, origin.longitude, destination.latitude, destination.longitude).then((result) async {
      if (result.isNotEmpty) {
        polylineCoordinates = [];
        for (var point in result) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        Polyline polyline = Polyline(
            polylineId: const PolylineId("jalur"),
            color: blackColor,
            points: polylineCoordinates,
            width: 6,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap);
        polylines.add(polyline);
        // setPriceAndDistance();
        await setActualDistance();
        notifyListeners();
      }
    });
  }

  Future<void> setActualDistance() async {
    try {
      // Get real distance
      var response = await Dio().get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${destinationLatLng.latitude},${destinationLatLng.longitude}&origins=${originLatLng.latitude},${originLatLng.longitude}&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs');
      log(" response of real distance:--->>> ${response.data}");

      var data = GoogleRouteDistanceResponseModal.fromJson(response.data);
      print("========>${data.toJson()}");
      distance = data.rows[0].elements[0].distance.text;
      totalDistance = data.rows[0].elements[0].distance.value;
      estimatedTime = data.rows[0].elements[0].duration.value;
      estimatedTimeToShow = data.rows[0].elements[0].duration.text;

      session.setEstimatedDistance =
          data.rows[0].elements[0].distance.value.toString();
      session.setEstimatedTime =
          data.rows[0].elements[0].duration.value.toStringAsFixed(1);

      notifyListeners();

      log("session distnace:--${session.estimatedDistance}");
      log("session duration:--${session.estimatedTime}");
    } catch (e) {
      print(e);
    }
  }

  // setPriceAndDistance() async {
  //   final double distanceInDouble =
  //       await getDistance(originLatLng, destinationLatLng);
  //   var distanceKm =
  //       ((distanceInDouble) / 1000.roundToDouble()).toStringAsFixed(2);
  //   distance = distanceKm;
  //   notifyListeners();
  // }

  Stream<TotalPriceState> fetchTotalPrice() async* {
    showLoading();
    // final double distanceInDouble =
    //     await getDistance(originLatLng, destinationLatLng);
    // var distanceKm =
    //     ((distanceInDouble) / 1000.roundToDouble()).toStringAsFixed(2);
    // var distanceMeter = double.parse(distanceKm) * 1000;

    var distanceMeter = double.parse(distance);

    log("Distance meter is;;;->>$distanceMeter");
    newState = TotalPriceLoading();
    DateFormat dateFormat = DateFormat.Hm();
    DateTime now = DateTime.now();
    DateTime start = dateFormat.parse("05:00");
    start = DateTime(now.year, now.month, now.day, start.hour, start.minute);
    DateTime end = dateFormat.parse("22:00");
    end = DateTime(now.year, now.month, now.day, end.hour, end.minute);
    String night = '0';
    if (now.isAfter(start) && now.isBefore(end)) {
    } else {
      night = '1';
    }
    final result = await getTotalPrice.call(
        _selectedCategory!.categoryId.toString(),
        distanceMeter.toString(),
        night);
    yield* result.fold(
      (failure) async* {
        logMe(failure.message);
        newState = TotalPriceFailure(failure: failure);
        dismissLoading();
      },
      (data) async* {
        log(data.toString());
        logMe("_priceeeee");
        logMe(data.data);
        price = data.data;
        notifyListeners();
        newState = TotalPriceLoaded(data: data);
        dismissLoading();
      },
    );
  }

  //Update Fare Price and vehicle Catagory
  updatePriceAndCatagortId({required fare, required catagoryId}) {
    price = fare;
    selectedVehicleId = catagoryId;
    notifyListeners();
  }

  updateIsAvailable({val}) {
    isAvailable = val;
    notifyListeners();
  }

  double metersToKilometers(int meters) {
    return meters / 1000;
  }

//Get all the Vehicles Catagories
  Stream<VehiclesCategoryState> fetchVehicleCategory() async* {
    log("-->>> distance privce --->>>>   $distance");
    log("estimated time is:  $estimatedTime");

    //Convert seconds to minute and round off

    String newTime = (estimatedTime / 60).toStringAsFixed(1);

    double dist = metersToKilometers(totalDistance);
    log("-->>> Total Distance in Km --->>>>   $dist");
    yield VehiclesCategoryLoading();

    final result = await getVehicleCatagory.call(dist.toString(), "0",
        "${originLatLng.latitude},${originLatLng.longitude}", newTime);
    yield* result.fold(
      (failure) async* {
        yield VehiclesCategoryFailure(failure: failure);
      },
      (data) async* {
        _vehiclesCategory = data.data;
        logMe("_priceCategory");
        logMe(_vehiclesCategory);
        yield VehiclesCategoryLoaded(data: _vehiclesCategory);
      },
    );

    log("--------****************" + vehicleCategory.toString());
  }

//Old Method to get vehicles Catagories
  // Stream<PriceCategoryState> fetchPriceCategory() async* {
  //   yield PriceCategoryLoading();

  //   final result = await getPriceCategory("10", "0", "30.7046083,76.6843826");
  //   yield* result.fold(
  //     (failure) async* {
  //       yield PriceCategoryFailure(failure: failure);
  //     },
  //     (data) async* {
  //       _priceCategory = data.data;
  //       logMe("_priceCategory");
  //       logMe(_priceCategory);
  //       yield PriceCategoryLoaded(data: _priceCategory);
  //     },
  //   );
  // }

//update selected car category

// Create or Submit Order
  Stream<CreateOrderState> submitOrder() async* {
    String newTime = (estimatedTime / 60).toStringAsFixed(1);
    log("Submit order Clicked");
    yield CreateOrderLoading();
    String txtLatLngOrigin =
        '${originLatLng.latitude},${originLatLng.longitude}';
    String txtLatLngDestination =
        '${destinationLatLng.latitude},${destinationLatLng.longitude}';

    log(txtLatLngOrigin.toString());
    log(txtLatLngDestination.toString());
    log(originAddress.toString());
    log(destinationAddress.toString());
    log(distance.toString());
    log(price.toString());
    log(_paymentMethod.toString());
    log(selectedVehicleId.toString());
    log("estimated distacnce while send order is:-->> $distance");
    log("estimated time while send order is:-->> $newTime");
    final dist = metersToKilometers(totalDistance);
    final formData = FormData.fromMap({
      'start_coordinate': txtLatLngOrigin,
      'end_coordinate': txtLatLngDestination,
      'start_address': originAddress,
      'end_address': destinationAddress,
      'distance': dist,
      'total': price,
      'estimated_time': newTime,
      'payment_method': (_paymentMethod == PaymentMethod.cash)
          ? "1"
          : (_paymentMethod == PaymentMethod.creditCard)
              ? "2"
              : (_paymentMethod == PaymentMethod.googlePay)
                  ? "3"
                  : "4",
      'vehicle_category_id': selectedVehicleId.toString(),
    });

    log(formData.toString());
    logMe("formData");
    // logMe(_selectedCategory!.categoryId.toString());
    final result = await createOrder.execute(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield CreateOrderFailure(failure: failure);
    }, (data) async* {
      logMe("Order Created ${data.id}");
      final session = locator<Session>();
      session.setOrderId = data.id.toString();
      session.setOrderStatus = Order.lookingDriver;
      yield CreateOrderLoaded(data: data);
    });
  }

// Get List of credit cards
  getListOfCard() async {
    var url = '${BASE_URL}api/webservice/card/list';

    var res = await dio.get(
      url,
      options: Options(headers: {"Authorization": "Bearer ${session.sessionToken}"}),
    );

    log("list of card are====>>>" + res.toString());
  }

  //Add credit card

  addCreditCard() {}
}
