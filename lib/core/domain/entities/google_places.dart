import 'package:equatable/equatable.dart';

import 'geometry.dart';

class GooglePlaceSearch extends Equatable {
  const GooglePlaceSearch({
    required this.formattedAddress,
    required this.geometry,
    required this.name,
    required this.place_id,
    required this.vicinity,
  });

  final String ?formattedAddress;
  final Geometry geometry;
  final String name;
  final String place_id;
  final String ?vicinity;

  @override
  List<Object?> get props => [
        formattedAddress,
        geometry,
        name,
    place_id,
    vicinity,
      ];
  toJson() {}
}
