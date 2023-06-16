import '../../domain/entities/vehicles_category.dart';

class VehiclesCategoryModel extends VehiclesCategory {
  const VehiclesCategoryModel({
    required num categoryId,
    required String categoryCar,
    required num priceMin,
    required num seat,
    required num extraKm,
    required num drivers,
    required dynamic time,
    required num totalFare,
  }) : super(
          categoryId: categoryId,
          categoryCar: categoryCar,
          priceMin: priceMin,
          seat: seat,
          extraKm: extraKm,
          drivers: drivers,
          time: time,
          totalFare: totalFare,
        );

  factory VehiclesCategoryModel.fromJson(Map<String, dynamic> json) =>
      VehiclesCategoryModel(
        categoryId: json['id'],
        categoryCar: json['category'],
        priceMin: json['min_km'],
        seat: json['seat'],
        extraKm: json['extra_km'],
        drivers: json['drivers'],
        totalFare: json['total_fair'],
        time: json['time'],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": categoryId,
        "category": categoryCar,
        "min_km": priceMin,
        "seat": seat,
        "extra_km": extraKm,
        "drivers": drivers,
        "totalFare": totalFare,
        "time": time,
      };
}
