import '../../domain/entities/vehicles_category.dart';

class VehiclesCategoryModel extends VehiclesCategory {
  const VehiclesCategoryModel({
    required num id,
    required String category,
    required double priceKm,
    required num minPrice,
    required String seat,
    required num extraKm,
    required num drivers,
    required dynamic time,
    required String totalFare,
    required double minKm,
    required dynamic newTotal,
    required dynamic pendingAmount,
    required dynamic isAvailable,
    required dynamic estimatedTime,
    required dynamic estimatedDistance,
  }) : super(
          categoryId: id,
          categoryCar: category,
          priceKm: priceKm,
          priceMin: minPrice,
          seat: seat,
          extraKm: extraKm,
          drivers: drivers,
          time: time,
          totalFare: totalFare,
          minKm: minKm,
          newTotal: newTotal,
          pendingAmount: pendingAmount,
          isAvailable: isAvailable,
          estimatedTime: estimatedTime,
          estimatedDistance: estimatedDistance,
        );

  factory VehiclesCategoryModel.fromJson(Map<String, dynamic> json) =>
      VehiclesCategoryModel(
        id: json['id'],
        category: json['category'],
        priceKm: json['price_km'],
        minPrice: json['min_price'],
        seat: json['seat'],
        extraKm: json['extra_km'],
        drivers: json['drivers'],
        totalFare: json['total_fair'],
        time: json['time'],
        minKm: json['min_km'],
        pendingAmount: json['pending_amount'],
        newTotal: json['new_total'],
        isAvailable: json['is_available'],
        estimatedDistance: json['estimated_distance'],
        estimatedTime: json['estimated_time'],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": categoryId,
        "category": categoryCar,
        "min_price": priceMin,
        "seat": seat,
        "extra_km": extraKm,
        "drivers": drivers,
        "totalFare": totalFare,
        "time": time,
        "min_km": priceMin,
        "newTotal": newTotal,
        "pendingAmount": pendingAmount,
        "isAvailable": isAvailable,
        "estimatedTime": estimatedTime,
        "estimatedDistance": estimatedDistance,
      };
}
