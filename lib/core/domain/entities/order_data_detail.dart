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

  // Factory method to create an OrderDataDetail instance from a Map (JSON)
  factory OrderDataDetail.fromJson(Map<String, dynamic> json) {
    return OrderDataDetail(
      originAddress: json['originAddress'],
      destinationAddress: json['destinationAddress'],
      originLatLng: LatLng(
        json['originLatLng']['latitude'],
        json['originLatLng']['longitude'],
      ),
      destinationLatLng: LatLng(
        json['destinationLatLng']['latitude'],
        json['destinationLatLng']['longitude'],
      ),
    );
  }

  // Convert OrderDataDetail instance to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'originAddress': originAddress,
      'destinationAddress': destinationAddress,
      'originLatLng': {
        'latitude': originLatLng.latitude,
        'longitude': originLatLng.longitude,
      },
      'destinationLatLng': {
        'latitude': destinationLatLng.latitude,
        'longitude': destinationLatLng.longitude,
      },
    };
  }

  @override
  List<Object?> get props => [
        originAddress,
        destinationAddress,
        originLatLng,
        destinationLatLng,
      ];
}
