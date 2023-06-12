import 'package:equatable/equatable.dart';

import 'geometry.dart';

class GooglePlaceSearch extends Equatable {
  const GooglePlaceSearch({
    required this.formattedAddress,
    required this.geometry,
    required this.name,
  });

  final String formattedAddress;
  final Geometry geometry;
  final String name;

  @override
  List<Object?> get props => [
        formattedAddress,
        geometry,
        name,
      ];
  toJson() {}
}
