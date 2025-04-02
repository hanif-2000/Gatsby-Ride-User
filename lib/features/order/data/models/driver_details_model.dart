// To parse this JSON data, do
//
//     final getDriverDetailsResponseModel = getDriverDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

GetDriverDetailsResponseModel getDriverDetailsResponseModelFromJson(
        String str) =>
    GetDriverDetailsResponseModel.fromJson(json.decode(str));

String getDriverDetailsResponseModelToJson(
        GetDriverDetailsResponseModel data) =>
    json.encode(data.toJson());

class GetDriverDetailsResponseModel {
  int success;
  DriverDetailsData message;

  GetDriverDetailsResponseModel({
    required this.success,
    required this.message,
  });

  factory GetDriverDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetDriverDetailsResponseModel(
        success: json["success"],
        message: DriverDetailsData.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message.toJson(),
      };
}

class DriverDetailsData {
  int id;
  String name;
  String image;
  String phone;
  String carModel;
  String plateNumber;
  dynamic rating;

  DriverDetailsData({
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.carModel,
    required this.plateNumber,
    required this.rating,
  });

  factory DriverDetailsData.fromJson(Map<String, dynamic> json) =>
      DriverDetailsData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        phone: json["phone"],
        carModel: json["car_model"],
        plateNumber: json["plate_number"],
        rating: json["rating"],
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
