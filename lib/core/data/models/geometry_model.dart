import '../../domain/entities/geometry.dart';
import '../../domain/entities/location.dart';
import 'location_model.dart';

class GeometryModel extends Geometry {
  const GeometryModel({required Location location}) : super(location: location);

  factory GeometryModel.fromJson(Map<String, dynamic> json) => GeometryModel(
        location: LocationModel.fromJson(json["location"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
      };
}
