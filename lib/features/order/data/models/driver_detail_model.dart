import 'package:appkey_taxiapp_user/features/order/domain/entities/driver_detail.dart';

class DriverDetailModel extends DriverDetail {
  const DriverDetailModel({
    required String name,
    required String phone,
    required String model,
    required String plat,
  }) : super(
          name: name,
          phone: phone,
          model: model,
          plat: plat,
        );

  factory DriverDetailModel.fromJson(Map<String, dynamic> json) =>
      DriverDetailModel(
        name: json['name'],
        phone: json['phone'],
        model: json['car_model'],
        plat: json['plate_number'],
      );

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "car_model": model,
        "plate_number": plat,
      };
}
