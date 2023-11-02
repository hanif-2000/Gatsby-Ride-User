import 'package:equatable/equatable.dart';

class VehiclesCategory extends Equatable {
  final num categoryId, priceMin, drivers, extraKm;
  final String categoryCar, seat, totalFare;
  final double priceKm, minKm;

  final dynamic time, pendingAmount, newTotal;

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
        pendingAmount
      ];
}
