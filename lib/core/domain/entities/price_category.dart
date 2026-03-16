import 'package:equatable/equatable.dart';

class PriceCategory extends Equatable {
  final num categoryId, priceKm, priceMin, seat;
  final String categoryCar;
  final dynamic pendingAmount, newTotal, estimatedDistance, estimatedTime;
  final num totalFare;
  final num baseFare;
  final num techFee;
  final num pricePerMin;
  final num nightService;
  final String? image;
  final String isAvailable;

  const PriceCategory({
    required this.categoryId,
    required this.categoryCar,
    required this.priceMin,
    required this.seat,
    required this.priceKm,
    required this.pendingAmount,
    required this.newTotal,
    required this.estimatedDistance,
    required this.estimatedTime,
    required this.totalFare,
    required this.baseFare,
    required this.techFee,
    required this.pricePerMin,
    required this.nightService,
    this.image,
    this.isAvailable = 'yes',
  });

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        categoryId,
        categoryCar,
        priceMin,
        seat,
        priceKm,
        pendingAmount,
        newTotal,
        estimatedDistance,
        estimatedTime,
        totalFare,
        baseFare,
        techFee,
        pricePerMin,
        nightService,
        image,
        isAvailable,
      ];
}