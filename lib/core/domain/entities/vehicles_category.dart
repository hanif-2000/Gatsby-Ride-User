import 'package:equatable/equatable.dart';

class VehiclesCategory extends Equatable {
  final num categoryId, priceMin, seat, drivers, extraKm;
  final String categoryCar, totalFare;

  final dynamic time;

  const VehiclesCategory({
    required this.categoryId,
    required this.categoryCar,
    required this.priceMin,
    required this.seat,
    required this.extraKm,
    required this.drivers,
    this.time,
    required this.totalFare,
  });

  toJson() {}

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        categoryId,
        categoryCar,
        priceMin,
        seat,
        extraKm,
        drivers,
        time,
        totalFare
      ];
}
