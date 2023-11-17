import 'package:GetsbyRideshare/features/order/domain/entities/driver_detail.dart';

class DriverDetailModel extends DriverDetail {
  DriverDetailModel({
    required String name,
    required String phone,
    required String model,
    required String plat,
    required int id,
    String? image,
    int? rating,
  }) : super(
          name: name,
          phone: phone,
          model: model,
          plat: plat,
          rating: rating,
          id: id,
          image: image,
        );

  factory DriverDetailModel.fromJson(Map<String, dynamic> json) =>
      DriverDetailModel(
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        model: json['car_model'] ?? '',
        plat: json['plate_number'] ?? '',
        rating: json['rating'] ?? 0,
        id: json["id"],
        image: json['image'] ?? '',
      );

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "car_model": model,
        "plate_number": plat,
        "rating": rating,
        "id": id,
        "image": image,
      };
}
