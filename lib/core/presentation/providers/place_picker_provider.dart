import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:appkey_taxiapp_user/core/domain/usecases/get_google_place.dart';
import 'package:appkey_taxiapp_user/core/static/assets.dart';
import 'package:appkey_taxiapp_user/core/static/enums.dart';
import 'package:appkey_taxiapp_user/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lctn;

import 'place_auto_complete_state.dart';

class PlacePickerProvider with ChangeNotifier {
  final GetGooglePlace getGooglePlace;
  final TextEditingController _controller = TextEditingController();
  final lctn.Location locationService = lctn.Location();

  late GoogleMapController googleMapController;
  CameraPosition? cameraPosition;
  PlaceAutoCompleteState _state = PlaceInitial();
  Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  //initial
  late Map<String, dynamic> placeDataOrigin;
  late Map<String, dynamic> placeDataDestination;
  late String originName, destinationName;
  late LatLng originLatLng, destinationLatLng;

  late BitmapDescriptor redMarker;
  String addressSelected = '';
  bool isCurrentLoading = false;
  bool isAddressLoading = false;

  bool get textFieldIsEmpty => _controller.text.isEmpty;

  PlacePickerProvider({required this.getGooglePlace});

  String _changeValue = "";

  set setOriginAddress(val) {
    addressSelected = val;
    isCurrentLoading = false;
    originLatLng = LatLng(
        cameraPosition!.target.latitude, cameraPosition!.target.longitude);
    originName = addressSelected;
    placeDataOrigin = {
      'pickUpCoordinate': originLatLng,
      'pickUpName': originName,
      'addressType': AddressType.origin,
    };

    notifyListeners();
  }

  set setDestinationAddress(val) {
    addressSelected = val;
    isCurrentLoading = false;
    destinationLatLng = LatLng(
        cameraPosition!.target.latitude, cameraPosition!.target.longitude);
    destinationName = addressSelected;
    placeDataDestination = {
      'pickUpCoordinate': destinationLatLng,
      'pickUpName': destinationName,
      'addressType': AddressType.destination,
    };
    logMe("setDestinationAddress");
    logMe(placeDataDestination);

    notifyListeners();
  }

  set newState(PlaceAutoCompleteState state) {
    _state = state;
    notifyListeners();
  }

  void clearController() {
    _controller.clear();
    notifyListeners();
  }

  void resetSearch() {
    _controller.clear();
    _state = PlaceInitial();
    notifyListeners();
  }

  set changeValue(String value) {
    _changeValue = value;
    notifyListeners();
  }

  setupCurrentLatLongValues(
      LatLng latLng, String address, AddressType addressType) {
    if (addressType == AddressType.origin) {
      originLatLng = latLng;
      addressSelected = address;
      placeDataOrigin = {
        'pickUpCoordinate': originLatLng,
        'pickUpName': addressSelected,
        'addressType': AddressType.origin,
      };
      notifyListeners();
    } else {
      destinationLatLng = latLng;
      addressSelected = address;
      placeDataDestination = {
        'pickUpCoordinate': destinationLatLng,
        'pickUpName': addressSelected,
        'addressType': AddressType.destination,
      };
      notifyListeners();
    }
  }

  setCurrentLoad() {
    isCurrentLoading = true;
    notifyListeners();
  }

  setAddressLoad(value) {
    isAddressLoading = value;
    notifyListeners();
  }

  getCurrentLocation() async {
    try {
      bool serviceStatus = await locationService.serviceEnabled();
      if (serviceStatus) {
        lctn.LocationData locationData = await locationService.getLocation();
        originLatLng = LatLng(locationData.latitude!, locationData.longitude!);
        List<Placemark> p = await placemarkFromCoordinates(
            originLatLng.latitude, originLatLng.longitude);

        Placemark place = p[0];

        googleMapController.moveCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(originLatLng.latitude, originLatLng.longitude),
                zoom: 18)));
        cameraPosition = CameraPosition(
            target: LatLng(originLatLng.latitude, originLatLng.longitude),
            zoom: 18);

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

  TextEditingController get controller => _controller;
  PlaceAutoCompleteState get state => _state;
  String get changeValue => _changeValue;

  Future<void> fetchGooglePlaces() async {
    newState = PlaceLoading();

    final placeResult = await getGooglePlace(_controller.text);
    placeResult.fold(
      (failure) async {
        newState = PlaceFailure(failure: failure);
      },
      (data) async {
        logMe(data);
        newState = PlaceAutoLoaded(data: data);
      },
    );
  }
}
