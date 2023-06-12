import '../../domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({required double lat, required double lng})
      : super(lat: lat, lng: lng);

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
