import 'package:GetsbyRideshare/core/domain/entities/vehicles_category.dart';
import 'package:equatable/equatable.dart';

class VehiclesCategoryList extends Equatable {
  final bool success;
  final List<VehiclesCategory> data;

  const VehiclesCategoryList({
    required this.success,
    required this.data,
  });

  @override
  List<Object?> get props => [
        success,
        data,
      ];

  Map<String, dynamic> toJson() => {};
}
