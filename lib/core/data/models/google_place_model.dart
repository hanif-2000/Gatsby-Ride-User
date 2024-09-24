import '../../domain/entities/geometry.dart';
import '../../domain/entities/google_places.dart';
import 'geometry_model.dart';

class GooglePlaceSearchModel extends GooglePlaceSearch {
  const GooglePlaceSearchModel(
      { String? formattedAddress,
      required Geometry geometry,
      required String place_id,
      required String name,
        String? vicinity})
      : super(formattedAddress: formattedAddress, geometry: geometry, name: name,place_id: place_id,vicinity: vicinity);

  factory GooglePlaceSearchModel.fromJson(Map<String, dynamic> json) =>
      GooglePlaceSearchModel(
        formattedAddress: json["formatted_address"]??json["vicinity"]??"",
        geometry: GeometryModel.fromJson(json["geometry"]),
        name: json["name"],
        place_id: json["place_id"],
        vicinity: json["vicinity"],

      );

  @override
  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "name": name,
        "place_id": place_id,
      };
}
