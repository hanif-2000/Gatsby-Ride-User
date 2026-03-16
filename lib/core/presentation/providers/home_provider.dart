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
import '../../utility/push_notification_helper.dart';
import '../../utility/session_helper.dart';
import 'create_order_state.dart';

class HomeProvider with ChangeNotifier {
  var dio = Dio();
  final GetTotalPrice getTotalPrice;
  final GetPriceCategory getPriceCategory;
  final CreateOrder createOrder;
  final GetVehiclesCategory getVehicleCatagory;

  TotalPriceState _stateLoadPrice = TotalPriceInitial();

  bool isDestinationSelected = false;

  toggleIsDestinationSelected() {
    isDestinationSelected = true;
    notifyListeners();
  }

  String estimatedTimeToShow = '';

  final session = locator<Session>();

  LatLng defaultLatLng = LatLng(55.170834, -118.794724);

  WebSocket? socket;

  bool isAccepted = false;
  bool isMapLoading = true;

  updateTermsAccepted(value) {
    isAccepted = value;
    notifyListeners();
  }

  double lat = 55.170834;
  double long = -118.794724;

  late GoogleMapController googleMapController;
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

  // setter
  set setSelectedCategory(val) {
    _selectedCategory = val;
    notifyListeners();
  }

  updateEstimatedTime(val) {
    estimatedTime = val;
    notifyListeners();
  }

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

  // clear state
  Future<void> clearState() async {
    polylines.clear();
    destinationIsFilled = false;
    distance = "0";
    totalDistance = 0;
    price = "";
    _paymentMethod = null;
    selectedVehicleId = "";
    _selectedCategory = null;
    markers.clear();
    selectedVehicleIndex = -1;
    originIsFilled = false;
    originAddress = 'Pickup Address';
    isDestinationSelected = false;
    _vehiclesCategory = [];
    notifyListeners();
    await NotificationService().clearAllNotifications();
  }

  clearOldRideData() {
    log("*********CLEAR PREVIOUS POLYLINE CALLED-------");
    polylines.clear();
    destinationIsFilled = false;
    markers.clear();
    destinationAddress = appLoc.destination;
    notifyListeners();
  }

  updateSelectedVehicleIndex({index}) {
    selectedVehicleIndex = index;
    notifyListeners();
  }

  List carsImageList = [
    "assets/icons/economy_car.png",
    "assets/icons/xl_car.png",
    "assets/icons/tesla_car.png",
    "assets/icons/economy_car.png",
    "assets/icons/xl_car.png",
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

  // constructor
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
    getBytesFromAsset(initialPickUpIcon, 100).then((value) async {
      initialPickMarker = BitmapDescriptor.bytes(value);
    });

    final session = locator<Session>();

    log("session.currentLat is :${session.currentLat}");
    log("session.currentLong is :${session.currentLong}");

    if (session.currentLat != '') {
      updateLatLong(
        latitude: session.currentLat,
        // ✅ FIX 1: currentLong use karo, currentLat nahi
        longitude: session.currentLong,
      );
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

  updateLatLong({required double latitude, required double longitude}) {
    lat = latitude;
    long = longitude;
    notifyListeners();
  }

  // ✅ FIX 2: setCurrentLocation — sirf origin set karo
  Future<void> setCurrentLocation() async {
    print("*********** GET Current Location******************* ");
    clearState();
    clearOldRideData();
    destinationAddress = appLoc.destination; // ✅ Reset to placeholder
    originAddress = 'Pickup Address';
    destinationIsFilled = false;
    originIsFilled = false;
    try {
      final locationData = await DirectionHelper.getCurrentLocation();
      if (locationData != null) {
        logMe("${locationData.latitude} ${locationData.longitude}",
            name: "LOCATION DATA");

        // ✅ Sirf origin set karo — destination user select karega
        originLatLng = LatLng(locationData.latitude, locationData.longitude);

        await setAddressFromLatLng();
      } else {
        await setDefaultLocation();
      }
      isMapLoading = false;
      notifyListeners();
    } catch (e) {
      SmartDialog.dismiss();
      await setDefaultLocation();
    }
    notifyListeners();
  }

  // ✅ FIX 3: setDefaultLocation — destination set mat karo
  FutureOr<void> setDefaultLocation() async {
    originLatLng = defaultLatLng;
    // ❌ destinationLatLng = defaultLatLng; // REMOVED — user select karega
    await setAddressFromLatLng();
  }

  // ✅ FIX 4: setAddressFromLatLng — destinationAddress origin se mat set karo
  Future<void> setAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          originLatLng.latitude, originLatLng.longitude);
      session.setCurrentLat = originLatLng.latitude;
      session.setCurrentLong = originLatLng.longitude;
      if (p.isEmpty) {
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
      await googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(originLatLng.latitude, originLatLng.longitude),
        zoom: zoom,
      )));

      // ✅ Sirf originAddress set karo
      originAddress =
          "${place.street}, ${place.subLocality}, ${place.locality}";

      // ❌ destinationAddress = origin se mat set karo — REMOVED
      // destinationAddress = "${place.street}, ${place.subLocality}, ${place.locality}";

      markers[markerId] = marker;
      notifyListeners();
    } catch (e) {
      logMe(e);
    }
  }

  displayResult(
      LatLng latlng, String address, AddressType addressType) async {
    final MarkerId markerId = MarkerId(
        addressType == AddressType.origin ? "origin" : "destination");
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
      CameraUpdate cu =
          CameraUpdate.newLatLngBounds(getBounds(listMarker), 75);
      googleMapController.animateCamera(cu);
      notifyListeners();
    } catch (e) {
      logMe("error dislay ${e.toString()}");
    }
  }

  Future<void> setPolylinesDirection(
      LatLng origin, LatLng destination) async {
    polylines.clear();
    await DirectionHelper()
        .getRouteBetweenCoordinates(origin.latitude, origin.longitude,
            destination.latitude, destination.longitude)
        .then((result) async {
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
      } else {
        log("⚠️ Polyline empty — still fetching distance directly");
      }

      await setActualDistance();
      notifyListeners();
    });
  }

  Future<void> setActualDistance() async {
    try {
      var response = await Dio().get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${destinationLatLng.latitude},${destinationLatLng.longitude}&origins=${originLatLng.latitude},${originLatLng.longitude}&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs');

      log("response of real distance:--->>> ${response.data}");

      var data = GoogleRouteDistanceResponseModal.fromJson(response.data);

      totalDistance = data.rows[0].elements[0].distance.value;
      distance = totalDistance.toString();
      estimatedTime = data.rows[0].elements[0].duration.value;
      estimatedTimeToShow = data.rows[0].elements[0].duration.text;

      session.setEstimatedDistance = totalDistance.toString();
      session.setEstimatedTime = data.rows[0].elements[0].duration.value.toStringAsFixed(1);

      log("✅ Distance: $totalDistance meters (${metersToKilometers(totalDistance)} km)");
      log("✅ Time: $estimatedTime seconds (${(estimatedTime / 60).toStringAsFixed(1)} min)");

      notifyListeners();

      await _fetchVehicleCategoryWithActualValues();
    } catch (e) {
      print("setActualDistance error: $e");
    }
  }

  Future<void> _fetchVehicleCategoryWithActualValues() async {
    try {
      String newTime = (estimatedTime / 60).toStringAsFixed(1);
      double dist = metersToKilometers(totalDistance);

      log("✅ Fetching price categories with ACTUAL distance: $dist km, time: $newTime min");

      final result = await getVehicleCatagory.call(
        dist.toString(),
        "0",
        "${originLatLng.latitude},${originLatLng.longitude}",
        newTime,
      );

      result.fold(
        (failure) {
          log("❌ Price category fetch failed: ${failure.message}");
        },
        (data) {
          _vehiclesCategory = data.data;
          log("✅ Price categories updated: ${data.data.length} categories");
          notifyListeners();
        },
      );
    } catch (e) {
      log("_fetchVehicleCategoryWithActualValues error: $e");
    }
  }

  Stream<TotalPriceState> fetchTotalPrice() async* {
    showLoading();
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

  Stream<VehiclesCategoryState> fetchVehicleCategory() async* {
    log("-->>> distance price --->>>>   $distance");
    log("estimated time is:  $estimatedTime");

    String newTime = (estimatedTime / 60).toStringAsFixed(1);
    double dist = metersToKilometers(totalDistance);
    log("-->>> Total Distance in Km --->>>>   $dist");

    yield VehiclesCategoryLoading();

    final result = await getVehicleCatagory.call(
      dist.toString(),
      "0",
      "${originLatLng.latitude},${originLatLng.longitude}",
      newTime,
    );

    log("=== API RESULT RECEIVED ===");
    yield* result.fold(
      (failure) async* {
        log("=== FAILURE: ${failure.message} ===");
        yield VehiclesCategoryFailure(failure: failure);
      },
      (data) async* {
        log("=== SUCCESS: ${data.data.length} items ===");
        _vehiclesCategory = data.data;
        logMe("_priceCategory");
        logMe(_vehiclesCategory);
        yield VehiclesCategoryLoaded(data: _vehiclesCategory);
      },
    );

    log("--------****************" + vehicleCategory.toString());
  }

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
    log("estimated distance while send order is:-->> $distance");
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

  getListOfCard() async {
    var url = '${BASE_URL}api/webservice/card/list';
    var res = await dio.get(
      url,
      options: Options(
          headers: {"Authorization": "Bearer ${session.sessionToken}"}),
    );
    log("list of card are====>>>" + res.toString());
  }

  addCreditCard() {}
}