import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/history/presentation/providers/ratings_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/presentation/providers/form_provider.dart';
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
    updatePolylines();
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
  Completer<GoogleMapController> controller = Completer();

  final Set<Marker> markers = {};
  final Set<Polyline> polyline = {};

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

    updatePolylines();

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

  updatePolylines() async {
    markers.clear();
    // declared for loop for various locations
    for (int i = 0; i < latLen.length; i++) {
      markers.add(
          // added markers
          Marker(
        markerId: MarkerId(i.toString()),
        position: latLen[i],
        // infoWindow: InfoWindow(
        //   title: 'HOTEL',
        //   snippet: '5 Star Hotel',
        // ),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)),
            'assets/icons/location4x.png'),
      ));

      polyline.add(Polyline(
        width: 5,
        polylineId: PolylineId('1'),
        points: latLen,
        color: blackColor,
      ));

      notifyListeners();
    }
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
