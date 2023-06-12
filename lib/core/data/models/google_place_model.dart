import '../../domain/entities/geometry.dart';
import '../../domain/entities/google_places.dart';
import 'geometry_model.dart';

class GooglePlaceSearchModel extends GooglePlaceSearch {
  const GooglePlaceSearchModel(
      {required String formattedAddress,
      required Geometry geometry,
      required String name})
      : super(
            formattedAddress: formattedAddress, geometry: geometry, name: name);

  factory GooglePlaceSearchModel.fromJson(Map<String, dynamic> json) =>
      GooglePlaceSearchModel(
        formattedAddress: json["formatted_address"],
        geometry: GeometryModel.fromJson(json["geometry"]),
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "name": name,
      };
}
