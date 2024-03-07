import 'package:GetsbyRideshare/core/domain/entities/price_category.dart';

class PriceCategoryModel extends PriceCategory {
  const PriceCategoryModel({
    required num categoryId,
    required String categoryCar,
    required num priceMin,
    required num seat,
    required num priceKm,
    required dynamic pendingAmount,
    required dynamic estimatedDistance,
    required dynamic estimatedTime,
    required dynamic newTotal,
  }) : super(
            categoryId: categoryId,
            categoryCar: categoryCar,
            priceMin: priceMin,
            seat: seat,
            priceKm: priceKm,
            pendingAmount: pendingAmount,
            estimatedDistance: estimatedDistance,
            estimatedTime: estimatedTime,
            newTotal: newTotal);

  factory PriceCategoryModel.fromJson(Map<String, dynamic> json) =>
      PriceCategoryModel(
          categoryId: json['id'],
          categoryCar: json['category'],
          priceMin: json['min_km'],
          seat: json['seat'],
          priceKm: json['price_km'],
          pendingAmount: json['pending_amount'],
          estimatedDistance: json['estimated_distance'],
          estimatedTime: json['estimated_time'],
          newTotal: json['new_total']);

  @override
  Map<String, dynamic> toJson() => {
        "id": categoryId,
        "category": categoryCar,
        "min_km": priceMin,
        "seat": seat,
        "price_km": priceKm,
        "pendingAmount": pendingAmount,
        "newTotal": newTotal,
        "estimatedTime": estimatedTime,
        "estimatedDistance": estimatedDistance,
      };
}
