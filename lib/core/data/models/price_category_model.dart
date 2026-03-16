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
    required num totalFare,
    required num baseFare,
    required num techFee,
    required num pricePerMin,
    required num nightService,
    String? image,
    String isAvailable = 'yes',
  }) : super(
          categoryId: categoryId,
          categoryCar: categoryCar,
          priceMin: priceMin,
          seat: seat,
          priceKm: priceKm,
          pendingAmount: pendingAmount,
          estimatedDistance: estimatedDistance,
          estimatedTime: estimatedTime,
          newTotal: newTotal,
          totalFare: totalFare,
          baseFare: baseFare,
          techFee: techFee,
          pricePerMin: pricePerMin,
          nightService: nightService,
          image: image,
          isAvailable: isAvailable,
        );

  factory PriceCategoryModel.fromJson(Map<String, dynamic> json) =>
      PriceCategoryModel(
        categoryId: _toNum(json['id']),
        categoryCar: json['category']?.toString() ?? '',
        priceMin: _toNum(json['min_km']),
        seat: _toNum(json['seat']),
        priceKm: _toNum(json['price_km']),
        pendingAmount: json['pending_amount'] ?? 0,
        estimatedDistance: json['estimated_distance'] ?? 0,
        estimatedTime: json['estimated_time'] ?? 0,
        newTotal: _toNum(json['total']),
        totalFare: _toNum(json['total']),
        baseFare: _toNum(json['base_fare']),
        techFee: _toNum(json['tech_fee']),
        pricePerMin: _toNum(json['price_min']),
        nightService: _toNum(json['night_service']),
        image: json['image'],
        isAvailable: json['is_available']?.toString() ?? 'yes',
      );

  static num _toNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    return num.tryParse(value.toString()) ?? 0;
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": categoryId,
        "category": categoryCar,
        "min_km": priceMin,
        "seat": seat,
        "price_km": priceKm,
        "pending_amount": pendingAmount,
        "total": totalFare,
        "estimated_time": estimatedTime,
        "estimated_distance": estimatedDistance,
        "base_fare": baseFare,
        "tech_fee": techFee,
        "price_min": pricePerMin,
        "night_service": nightService,
        "image": image,
        "is_available": isAvailable,
      };
}