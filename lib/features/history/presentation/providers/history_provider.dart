import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/history/presentation/providers/ratings_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/static/assets.dart';
import '../../../../core/utility/direction_helper.dart';
import '../../data/models/history_response_model.dart';
import '../../domain/usecases/get_history.dart';
import '../../domain/usecases/get_ratings.dart';
import 'history_state.dart';

class HistoryProvider extends FormProvider {
  final GetHistory getHistory;
  final GetRating getRatings;

  HistoryOrder? _history;
  HistoryOrder? get history => _history;

  HistoryProvider({
    required this.getHistory,
    required this.getRatings,
  }) {
    // updatePolylines();
  }
  late GoogleMapController googleMapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late BitmapDescriptor pickUpMarker, destinationMarker;

  setPolylineDirection(LatLng origin, LatLng destination) async {
    polylines.clear();
    await DirectionHelper()
        .getRouteBetweenCoordinates(origin.latitude, origin.longitude,
            destination.latitude, destination.longitude)
        .then(
      (result) {
        logMe('Polyline ---> ${result.toString()}');
        if (result.isNotEmpty) {
          polylineCoordinates = [];
          for (var point in result) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }

          Polyline polyline = Polyline(
              polylineId: const PolylineId("jalur"),
              color: Colors.black,
              points: polylineCoordinates,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap);
          polylines.add(polyline);
          logMe('Polyline in the list - ${polylines.toString()}');
          notifyListeners();
        }
      },
    );
  }

  createPickupAndDropMarker(
    LatLng pickup,
    LatLng drop,
  ) async {
    try {
      logMe('Create in creating marker --> ');
      MarkerId pickupMarkerId = const MarkerId("pickup");
      MarkerId dropMarkerId = const MarkerId("drop");
      final Marker marker = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: pickupMarkerId,
        position: LatLng(pickup.latitude, pickup.longitude),
        icon: await getBytesFromAsset(initialPickUpIcon, 200).then((value) {
          return pickUpMarker = BitmapDescriptor.fromBytes(value);
        }),
        // rotation: locationData.heading!,
        onTap: () {},
      );
      final Marker dropMarker = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: dropMarkerId,
        position: LatLng(drop.latitude, drop.longitude),
        icon: await getBytesFromAsset(destinationIcon, 100).then((value) {
          return destinationMarker = BitmapDescriptor.fromBytes(value);
        }),
        // rotation: locationData.heading!,
        onTap: () {},
      );

      markers[pickupMarkerId] = marker;
      markers[dropMarkerId] = dropMarker;
      notifyListeners();

      List<Marker> listMarker = [];
      markers.forEach((k, v) => listMarker.add(v));
      CameraUpdate cameraUpdate =
          CameraUpdate.newLatLngBounds(getBounds(listMarker), 75);
      googleMapController.animateCamera(cameraUpdate);

      logMe('Marker created -- --> ${markers.length}');
    } catch (e) {
      logMe('Error in creating marker --> $e');
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

  // created controller to display Google Maps
  // Completer<GoogleMapController> controller = Completer();

  // final Set<Marker> markers = {};

  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // final Set<Polyline> polyline = {};

  Set<Polyline> polylines = {};

  MarkerId markerId = const MarkerId("pickUp");

  List<LatLng> polylineCoordinates = [];

  late BitmapDescriptor trackedMarker;

  // list of locations to display polylines
  List<LatLng> latLen = [
    LatLng(19.0759837, 72.8776559),
    LatLng(28.679079, 77.069710),
  ];

  double originLat = 0.0;
  double originLang = 0.0;
  // double destinationLat = 0.0;
  // double destinationLang = 0.0;

  updateLatLong({latOrigin, longOrigin, latDestination, langDestination}) {
    // latLen = [];

    originLat = double.parse(latOrigin);
    originLang = double.parse(longOrigin);
    latLen.clear();
    latLen = [
      LatLng(double.parse(latOrigin), double.parse(longOrigin)),
      LatLng(double.parse(latDestination), double.parse(langDestination)),
    ];

    // updatePolylines();

    notifyListeners();

    logMe("Lat Long update successfull");

    log(latLen.toString());
  }

  Stream<HistoryState> fetchHistory() async* {
    yield HistoryLoading();
    final result = await getHistory();
    yield* result.fold((failure) async* {
      logMe("error");
      logMe(failure);
      yield HistoryFailure(failure: failure.message);
    }, (data) async* {
      yield HistoryLoaded(data: data);
    });
  }

//Get Ratings and review list
  //Order Rating
  Stream<GetRatingState> getRatingsAndReviews({driverId}) async* {
    yield GetRatingLoading();
    final formData = FormData.fromMap({"id": driverId, "type": 1});
    final result = await getRatings.execute(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield GetRatingFailure(failure: failure);
    }, (result) async* {
      yield GetRatingLoaded(data: result);
    });

    notifyListeners();
  }
}
