import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:GetsbyRideshare/core/domain/entities/vehicles_category.dart';
import 'package:GetsbyRideshare/core/domain/usecases/get_total_price.dart';
import 'package:GetsbyRideshare/core/presentation/providers/price_category_state.dart';
import 'package:GetsbyRideshare/core/presentation/providers/total_price_state.dart';
import 'package:GetsbyRideshare/core/presentation/providers/vehicle_category_state.dart';
import 'package:GetsbyRideshare/core/static/assets.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/static/enums.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/order/domain/usecases/create_oder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as lctn;
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

  //Initial
  final lctn.Location locationService = lctn.Location();
  // CameraPosition kJapanCoordinate = CameraPosition(
  //   target: LatLng(lat, long),
  //   zoom: 14.4746,
  // );
  TotalPriceState _stateLoadPrice = TotalPriceInitial();

  bool isDestinationSelected = false;

  //Toggle isDestination selected
  toggleIsDestinationSelected() {
    isDestinationSelected = true;
    notifyListeners();
  }

  String estimatedTimeToShow = '';

  Session session = locator<Session>();

//Socket

  WebSocket? socket;

  //Connec to Socket
  connectToSocket() {
    logMe(
        'Socket ============= chat Token : ${session.chatToken} ================');
    logMe(
        'Socket ============= User Id Token :  ${session.userId} ================');

    socket = WebSocket(Uri.parse(

        // 'ws://shakti.parastechnologies.in:8051?token=597011984&room=0&userID=1'
        'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}'));

    logMe('Socket ============= Connecting to Socket ================');
    socket!.connection.listen((event) {
      logMe('Socket on Listen ---> ${event.toString()}');

      if (event is Connected) {
        // listenRequests();
        // sendRequest();

        log("=====event======>>>>> " + event.toString());
      } else if (event is Disconnected) {
        log("Socket === Event is Disconnected ===");
        log("Socket === reason ${event.reason}");
      }
    });
  }

  //send request to socket

  sendRequest() {
    socket!
        // .send("serviceType: UserBookDriver, id: ${session.userId.toString()}");
        .send(jsonEncode({
      "serviceType": "UserBookDriver",
      "UserID": "${session.userId.toString()}"
    }));

    socket!.connection.listen((state) => print('state: "$state"'));

    log("send request");
  }

  bool isAccepted = false;

  updateTermsAccepted(value) {
    isAccepted = value;
    notifyListeners();
  }

  double lat = 0.0;
  double long = 0.0;

  late GoogleMapController googleMapController;
  // Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng originLatLng, destinationLatLng;
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor pickUpMarker, destinationMarker, initialPickMarker;
  String originAddress = '';
  bool destinationIsFilled = false;
  bool originIsFilled = false;
  String destinationAddress = appLoc.destination;
  String distance = "0", price = "";
  int estimatedTime = 0;
  String time = '';
  late Text originText;
  late Text destinationText;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  static List<PriceCategory> _priceCategory = [];
  PriceCategory? _selectedCategory;
  PaymentMethod? _paymentMethod;

  int selectedVehicleIndex = -1;

  String selectedVehicleId = '';

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
  clearState() async {
    await sessionClearOrder();
    session.setOrderStatus = 100;
    polylines.clear();
    destinationIsFilled = false;
    distance = "0";
    price = "0";
    _selectedCategory = null;
    _paymentMethod = null;

    markers.clear();
    selectedVehicleIndex = -1;

    originIsFilled = false;

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
    getBytesFromAsset(driverMarkerIcon, 70).then((value) {
      driverMarker = BitmapDescriptor.fromBytes(value);
    });
    getBytesFromAsset(initialPickUpIcon, 250).then((value) async {
      pickUpMarker = BitmapDescriptor.fromBytes(value);
    });
    getBytesFromAsset(destinationIcon, 100).then((value) async {
      destinationMarker = BitmapDescriptor.fromBytes(value);
    });
    getBytesFromAsset(initialPickUpIcon, 250).then((value) async {
      initialPickMarker = BitmapDescriptor.fromBytes(value);
    });

    final session = locator<Session>();
    updateLatLong(
      latitude: double.parse(session.currentLat),
      longitude: double.parse(session.currentLong),
    );

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

//updat LatLong initially
  updateLatLong({required double latitude, required double longitude}) {
    lat = latitude;

    long = longitude;
    notifyListeners();
  }

//Set current location in map intially
  setCurrentLocation() async {
    log("Get current location  called");
    try {
      bool serviceStatus = await locationService.serviceEnabled();
      if (serviceStatus) {
        lctn.LocationData locationData = await locationService.getLocation();
        logMe("locationData");
        logMe(locationData);
        originLatLng = LatLng(locationData.latitude!, locationData.longitude!);
        destinationLatLng =
            LatLng(locationData.latitude!, locationData.longitude!);
        setAddressFromLatLng();
        //onlocation change
        locationService.onLocationChanged.listen((event) {});
      } else {
        try {
          bool serviceStatusResult = await locationService.requestService();
          logMe("Service status activated after request: $serviceStatusResult");
          if (serviceStatusResult) {
            setCurrentLocation();
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

//Get Current Location
  getCurrentLocation() async {
    log("get current location home provider =-===>");

    try {
      bool serviceStatus = await locationService.serviceEnabled();
      if (serviceStatus) {
        lctn.LocationData locationData = await locationService.getLocation();
        logMe("locationData");
        logMe(locationData);
        originLatLng = LatLng(locationData.latitude!, locationData.longitude!);

        getAddressFromLatLng();
        //onlocation change
        locationService.onLocationChanged.listen((event) {});
      } else {
        try {
          bool serviceStatusResult = await locationService.requestService();
          logMe("Service status activated after request: $serviceStatusResult");
          if (serviceStatusResult) {
            getCurrentLocation();
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

// Get address from lat and long
  getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          originLatLng.latitude, originLatLng.longitude);

      Placemark place = p[0];

      MarkerId markerId = const MarkerId("origin");
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(originLatLng.latitude, originLatLng.longitude),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: pickUpMarker,
        onTap: () {},
      );

      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(originLatLng.latitude, originLatLng.longitude),
        zoom: 16,
      )));

      originAddress =
          "${place.street}, ${place.subLocality}, ${place.locality}";
      originText = Text(
        originAddress,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      );
      String lat, long;
      lat = originLatLng.latitude.toString();
      long = originLatLng.longitude.toString();
      markers[markerId] = marker;

      originIsFilled = true;
      notifyListeners();
    } catch (e) {
      logMe(e);
    }
  }

// Set initial Marker in Map i.e Current Location
  setAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          originLatLng.latitude, originLatLng.longitude);

      Placemark place = p[0];

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

      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(originLatLng.latitude, originLatLng.longitude),
        zoom: 16,
      )));

      originAddress =
          "${place.street}, ${place.subLocality}, ${place.locality}";
      destinationAddress =
          "${place.street}, ${place.subLocality}, ${place.locality}";
      originText = Text(
        originAddress,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      );

      markers[markerId] = marker;
      notifyListeners();
    } catch (e) {
      logMe(e);
    }
  }

// Show marker on Map according to latlong and addresstype
  displayResult(LatLng latlng, String address, AddressType addressType) async {
    final MarkerId markerId =
        MarkerId(addressType == AddressType.origin ? "origin" : "destination");
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
        originText = Text(
          originAddress,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        );
        originLatLng = latlng;

        originIsFilled = true;

        if (destinationIsFilled) {
          await setPolylinesDirection(originLatLng, destinationLatLng);
        }
      } else {
        destinationAddress = address;
        destinationText = Text(
          destinationAddress,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        );
        destinationLatLng = latlng;
        destinationIsFilled = true;
        setPolylinesDirection(originLatLng, destinationLatLng);
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

  setPolylinesDirection(LatLng origin, LatLng destination) async {
    polylines.clear();
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
            color: blackColor,
            points: polylineCoordinates,
            width: 6,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap);
        polylines.add(polyline);
        // setPriceAndDistance();
        setActualDistance();
        notifyListeners();
      }
    });
  }

  setActualDistance() async {
    try {
      // Get real distance
      var response = await Dio().get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${destinationLatLng.latitude},${destinationLatLng.longitude}&origins=${originLatLng.latitude},${originLatLng.longitude}&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs');
      log(" response of real distance:--->>> ${response.data}");

      var data = GoogleRouteDistanceResponseModal.fromJson(response.data);
      distance = data.rows[0].elements[0].distance.text;
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
    final result = await getTotalPrice(_selectedCategory!.categoryId.toString(),
        distanceMeter.toString(), night);
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

//Get all the Vehicles Catagories
  Stream<VehiclesCategoryState> fetchVehicleCategory() async* {
    log("-->>> distance privce --->>>>   $distance");
    log("estimated time is:  $estimatedTime");

    //Convert seconds to minute and round off

    String newTime = (estimatedTime / 60).toStringAsFixed(1);

    String dist = distance.split(' ').first;
    yield VehiclesCategoryLoading();

    final result = await getVehicleCatagory(dist, "0",
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
  Stream<PriceCategoryState> fetchPriceCategory() async* {
    yield PriceCategoryLoading();

    final result = await getPriceCategory("10", "0", "30.7046083,76.6843826");
    yield* result.fold(
      (failure) async* {
        yield PriceCategoryFailure(failure: failure);
      },
      (data) async* {
        _priceCategory = data.data;
        logMe("_priceCategory");
        logMe(_priceCategory);
        yield PriceCategoryLoaded(data: _priceCategory);
      },
    );
  }

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

    final formData = FormData.fromMap({
      'start_coordinate': txtLatLngOrigin,
      'end_coordinate': txtLatLngDestination,
      'start_address': originAddress,
      'end_address': destinationAddress,
      'distance': distance.split(' ').first,
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
    var url =
        'https://php.parastechnologies.in/taxi/public/api/webservice/card/list';

    var res = await dio.get(
      url,
      options:
          Options(headers: {"Authorization": "Bearer ${session.sessionToken}"}),
    );

    log("list of card are====>>>" + res.toString());
  }

  //Add credit card

  addCreditCard() {}
}
