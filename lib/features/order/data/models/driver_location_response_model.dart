import 'package:equatable/equatable.dart';

class DriverLocationResponseModel extends Equatable {
  final String driverId;
  final String longLat;
  final num bearing;

  const DriverLocationResponseModel({
    required this.driverId,
    required this.longLat,
    required this.bearing,
  });

  @override
  List<Object?> get props => [driverId, longLat, bearing];

  factory DriverLocationResponseModel.fromJson(Map<String, dynamic> json) =>
      DriverLocationResponseModel(
        driverId: json['id'] ?? '',
        longLat: json['latLong'] ?? '',
        bearing: json['bearing'] ?? 0,
      );
  Map<String, dynamic> toJson() => {
        'id': driverId,
        'latLong': longLat,
        'bearing': bearing,
      };
}
