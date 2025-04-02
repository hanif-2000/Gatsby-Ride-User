// To parse this JSON data, do
//
//     final driverDetailResponseModel = driverDetailResponseModelFromJson(jsonString);

import 'dart:convert';

DriverDetailResponseModel driverDetailResponseModelFromJson(String str) =>
    DriverDetailResponseModel.fromJson(json.decode(str));

String driverDetailResponseModelToJson(DriverDetailResponseModel data) =>
    json.encode(data.toJson());

class DriverDetailResponseModel {
  int success;
  Message message;

  DriverDetailResponseModel({
    required this.success,
    required this.message,
  });

  factory DriverDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      DriverDetailResponseModel(
        success: json["success"],
        message: Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message.toJson(),
      };
}

class Message {
  dynamic id;
  String name;
  String image;
  String phone;
  String carModel;
  String plateNumber;
  dynamic rating;

  Message({
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.carModel,
    required this.plateNumber,
    required this.rating,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        phone: json["phone"] ?? '',
        carModel: json["car_model"] ?? '',
        plateNumber: json["plate_number"] ?? '',
        rating: json["rating"] ?? '0.0',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "phone": phone,
        "car_model": carModel,
        "plate_number": plateNumber,
        "rating": rating,
      };
}
