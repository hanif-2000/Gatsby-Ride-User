// To parse this JSON data, do
//
//     final driverUpdatedPositionModel = driverUpdatedPositionModelFromJson(jsonString);

import 'dart:convert';

DriverUpdatedPositionModel driverUpdatedPositionModelFromJson(String str) =>
    DriverUpdatedPositionModel.fromJson(json.decode(str));

String driverUpdatedPositionModelToJson(DriverUpdatedPositionModel data) =>
    json.encode(data.toJson());

class DriverUpdatedPositionModel {
  dynamic response;
  String message;
  String type;
  double latitude;
  double longitude;

  DriverUpdatedPositionModel({
    required this.response,
    required this.message,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  factory DriverUpdatedPositionModel.fromJson(Map<String, dynamic> json) =>
      DriverUpdatedPositionModel(
        response: json["Response"],
        message: json["message"],
        type: json["type"],
        latitude: json["Latitude"]?.toDouble(),
        longitude: json["Longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "Latitude": latitude,
        "Longitude": longitude,
      };
}
