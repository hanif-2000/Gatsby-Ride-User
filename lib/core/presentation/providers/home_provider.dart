import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:appkey_taxiapp_user/core/domain/usecases/get_total_price.dart';
import 'package:appkey_taxiapp_user/core/presentation/providers/price_category_state.dart';
import 'package:appkey_taxiapp_user/core/presentation/providers/total_price_state.dart';
import 'package:appkey_taxiapp_user/core/static/assets.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/static/enums.dart';
import 'package:appkey_taxiapp_user/core/static/order_status.dart';
import 'package:appkey_taxiapp_user/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/order/domain/usecases/create_oder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as lctn;

import '../../domain/entities/price_category.dart';
import '../../domain/usecases/get_price_category.dart';
import '../../utility/direction_helper.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';
import 'create_order_state.dart';

class HomeProvider with ChangeNotifier {
  //Constructor
  final GetTotalPrice getTotalPrice;
  final GetPriceCategory getPriceCategory;
  final CreateOrder createOrder;

  //Initial
  final lctn.Location locationService = lctn.Location();
  CameraPosition kJapanCoordinate = const CameraPosition(
    target: JAPAN_LATLNG,
    zoom: 14.4746,
  );
  TotalPriceState _stateLoadPrice = TotalPriceInitial();

  bool isDestinationSelected = false;

  //Toggle isDestination selected
  toggleIsDestinationSelected() {
    isDestinationSelected = true;
    notifyListeners();
  }

  late GoogleMapController googleMapController;
  // Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng originLatLng, destinationLatLng;
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor pickUpMarker, destinationMarker;
  String originAddress = '';
  bool destinationIsFilled = false;
  String destinationAddress = appLoc.destination;
  String distance = "0", price = "0";
  late Text originText;
  late Text destinationText;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  static List<PriceCategory> _priceCategory = [];
  PriceCategory? _selectedCategory;
  PaymentMethod? _paymentMethod;

  // getter
  List<PriceCategory> get priceCategory => _priceCategory;
  PriceCategory? get selectedCategory => _selectedCategory;
  PaymentMethod? get paymentMethod => _paymentMethod;
  TotalPriceState get stateLoadPrice => _stateLoadPrice;

  //setter
  set setSelectedCategory(val) {
    _selectedCategory = val;
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
    polylines.clear();
    destinationIsFilled = false;
    distance = "0";
    price = "0";
    _selectedCategory = null;
    _paymentMethod = null;
    markers.clear();
    notifyListeners();
  }

  //constructor
  HomeProvider(
      {required this.getTotalPrice,
      required this.getPriceCategory,
      required this.createOrder}) {
    getBytesFromAsset(driverMarkerIcon, 70).then((value) {
      driverMarker = BitmapDescriptor.fromBytes(value);
    });
    getBytesFromAsset(pickupIcon, 100).then((value) async {
      pickUpMarker = BitmapDescriptor.fromBytes(value);
    });
    getBytesFromAsset(destinationIcon, 100).then((value) async {
      destinationMarker = BitmapDescriptor.fromBytes(value);
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

  setCurrentLocation() async {
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

  getCurrentLocation() async {
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
      notifyListeners();
    } catch (e) {
      logMe(e);
    }
  }

  setAddressFromLatLng() async {
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

  displayResult(LatLng latlng, String address, AddressType addressType) async {
    final MarkerId markerId =
        MarkerId(addressType == AddressType.origin ? "origin" : "destination");
    try {
      final Marker marker = Marker(
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
        setPriceAndDistance();
        notifyListeners();
      }
    });
  }

  setPriceAndDistance() async {
    final double distanceInDouble =
        await getDistance(originLatLng, destinationLatLng);
    var distanceKm =
        ((distanceInDouble) / 1000.roundToDouble()).toStringAsFixed(2);
    distance = distanceKm;
    notifyListeners();
  }

  Stream<TotalPriceState> fetchTotalPrice() async* {
    showLoading();
    final double distanceInDouble =
        await getDistance(originLatLng, destinationLatLng);
    var distanceKm =
        ((distanceInDouble) / 1000.roundToDouble()).toStringAsFixed(2);
    var distanceMeter = double.parse(distanceKm) * 1000;
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

  Stream<PriceCategoryState> fetchPriceCategory() async* {
    yield PriceCategoryLoading();

    final result = await getPriceCategory();
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

  Stream<CreateOrderState> submitOrder() async* {
    yield CreateOrderLoading();
    String txtLatLngOrigin =
        '${originLatLng.latitude},${originLatLng.longitude}';
    String txtLatLngDestination =
        '${destinationLatLng.latitude},${destinationLatLng.longitude}';

    final formData = FormData.fromMap({
      'start_coordinate': txtLatLngOrigin,
      'end_coordinate': txtLatLngDestination,
      'start_address': originAddress,
      'end_address': destinationAddress,
      'distance': distance,
      'total': price,
      'payment_method': _paymentMethod == PaymentMethod.cash ? "1" : "2",
      'vehicle_category_id': _selectedCategory!.categoryId.toString(),
    });
    logMe("formData");
    logMe(_selectedCategory!.categoryId.toString());
    final result = await createOrder.execute(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield CreateOrderFailure(failure: failure);
    }, (data) async* {
      logMe("Order Created ${data.orderId}");
      final session = locator<Session>();
      session.setOrderId = data.orderId.toString();
      session.setOrderStatus = Order.lookingDriver;
      yield CreateOrderLoaded(data: data);
    });
  }
}
