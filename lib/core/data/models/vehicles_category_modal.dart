import '../../domain/entities/vehicles_category.dart';

class VehiclesCategoryModel extends VehiclesCategory {
  const VehiclesCategoryModel({
    required num id,
    required String category,
    required dynamic priceKm,
    required dynamic minPrice,
    required String seat,
    required dynamic extraKm,
    required dynamic drivers,
    required dynamic time,
    required String totalFare,
    required dynamic minKm,
    required dynamic newTotal,
    required dynamic pendingAmount,
    required dynamic isAvailable,
    required dynamic estimatedTime,
    required dynamic estimatedDistance,
    required dynamic base_fare,
    required dynamic tech_fee,
    required dynamic price_km,
    required dynamic price_min,
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
          tech_fee: tech_fee,
          base_fare: base_fare,
          price_min: price_min,
          price_km: price_km,
        );

  factory VehiclesCategoryModel.fromJson(Map<String, dynamic> json) =>
      VehiclesCategoryModel(
        id: json['id'] ?? 0,
        category: json['name']?.toString() ?? '',               // ✅ FIXED: was 'category', API sends 'name'
        priceKm: json['price_km'] ?? 0,
        minPrice: json['min_price'] ?? 0,
        seat: json['seat']?.toString() ?? '4',
        extraKm: json['extra_km'] ?? 0,
        drivers: json['drivers'] ?? 0,
        totalFare: json['price']?.toString() ?? '0',            // ✅ FIXED: was 'total', API sends 'price'
        time: json['time'] ?? 0,
        minKm: json['min_km'] ?? 0,
        pendingAmount: json['pending_amount'] ?? 0,
        newTotal: json['price']?.toString() ?? '0',             // ✅ FIXED: was 'total', API sends 'price'
        isAvailable: json['is_available']?.toString() ?? 'yes',
        estimatedDistance: json['estimated_distance'] ?? 0,
        estimatedTime: json['estimated_time'] ?? 0,
        base_fare: json['base_fare'] ?? 0,
        tech_fee: json['tech_fee'] ?? 0,
        price_km: json['price_km'] ?? 0,
        price_min: json['price_min'] ?? 0,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": categoryId,
        "name": categoryCar,
        "min_price": priceMin,
        "tech_fee": tech_fee,
        "base_fare": base_fare,
        "seat": seat,
        "extra_km": extraKm,
        "drivers": drivers,
        "price": totalFare,
        "time": time,
        "min_km": minKm,
        "new_total": newTotal,
        "pending_amount": pendingAmount,
        "is_available": isAvailable,
        "estimated_time": estimatedTime,
        "estimated_distance": estimatedDistance,
        "price_min": price_min,
        "price_km": price_km,
      };
}