import 'package:GetsbyRideshare/core/domain/entities/price_category.dart';

class PriceCategoryModel extends PriceCategory {
  const PriceCategoryModel({
    required num categoryId,
    required String categoryCar,
    required num priceMin,
    required num seat,
    required num priceKm,
  }) : super(
          categoryId: categoryId,
          categoryCar: categoryCar,
          priceMin: priceMin,
          seat: seat,
          priceKm: priceKm,
        );

  factory PriceCategoryModel.fromJson(Map<String, dynamic> json) =>
      PriceCategoryModel(
        categoryId: json['id'],
        categoryCar: json['category'],
        priceMin: json['min_km'],
        seat: json['seat'],
        priceKm: json['price_km'],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": categoryId,
        "category": categoryCar,
        "min_km": priceMin,
        "seat": seat,
        "price_km": priceKm,
      };
}
