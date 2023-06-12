import 'package:equatable/equatable.dart';

class PriceCategory extends Equatable {
  final num categoryId, priceKm, priceMin, seat;
  final String categoryCar;

  const PriceCategory({
    required this.categoryId,
    required this.categoryCar,
    required this.priceMin,
    required this.seat,
    required this.priceKm,
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
        priceKm,
      ];
}
