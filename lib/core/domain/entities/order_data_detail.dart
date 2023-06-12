import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderDataDetail extends Equatable {
  final String originAddress, destinationAddress;
  final LatLng originLatLng, destinationLatLng;

  const OrderDataDetail({
    required this.originAddress,
    required this.destinationAddress,
    required this.originLatLng,
    required this.destinationLatLng,
  });

  @override
  List<Object?> get props => [
        originAddress,
        destinationAddress,
        originLatLng,
        destinationLatLng,
      ];
}
