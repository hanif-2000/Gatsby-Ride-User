import 'package:equatable/equatable.dart';

class VehiclesCategory extends Equatable {
  final dynamic categoryId, priceMin, drivers, extraKm;
  final String categoryCar, seat, totalFare;
  final dynamic priceKm, minKm;

  final dynamic time,
      pendingAmount,
      newTotal,
      isAvailable,
      estimatedTime,
      estimatedDistance;

  const VehiclesCategory({
    required this.categoryId,
    required this.categoryCar,
    required this.priceMin,
    required this.seat,
    required this.extraKm,
    required this.drivers,
    required this.minKm,
    this.time,
    required this.totalFare,
    required this.priceKm,
    required this.pendingAmount,
    required this.newTotal,
    required this.isAvailable,
    required this.estimatedTime,
    required this.estimatedDistance,
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
        totalFare,
        priceKm,
        minKm,
        newTotal,
        pendingAmount,
        isAvailable,
        estimatedTime,
        estimatedDistance
      ];
}
