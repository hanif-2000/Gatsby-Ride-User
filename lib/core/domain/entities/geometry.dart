import 'package:equatable/equatable.dart';

import 'location.dart';

class Geometry extends Equatable {
  const Geometry({
    required this.location,
  });

  final Location location;

  @override
  List<Object?> get props => [location];

  toJson() {}
}
