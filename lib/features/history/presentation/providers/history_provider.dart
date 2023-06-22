import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/direction_helper.dart';
import '../../data/models/history_response_model.dart';
import '../../domain/usecases/get_history.dart';
import 'history_state.dart';

class HistoryProvider extends FormProvider {
  final GetHistory getHistory;

  HistoryOrder? _history;
  HistoryOrder? get history => _history;

  HistoryProvider({required this.getHistory}) {
    // getBytesFromAsset(trackedIcon, 200).then((value) async {
    //   trackedMarker = BitmapDescriptor.fromBytes(value);
    // });
  }

  MarkerId markerId = const MarkerId("pickUp");

  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  List<LatLng> polylineCoordinates = [];

  Set<Polyline> polylines = {};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // LatLng startLocation = LatLng(27.6683619, 85.3101895);
  // LatLng endLocation = LatLng(27.6688312, 85.3077329);

  late BitmapDescriptor trackedMarker;

  setPolylinesDirection(LatLng origin, LatLng destination) async {
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
        notifyListeners();
      }
    });
  }

  // final Marker marker = Marker(
  //   markerId: markerId,
  //   position: LatLng(latDriver, lngDriver),
  //   icon: driverMarker,
  //   rotation: bearing.toDouble(),
  //   onTap: () {},
  // );

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
}
