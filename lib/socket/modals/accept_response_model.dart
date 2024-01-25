// To parse this JSON data, do
//
//     final acceptResponseModel = acceptResponseModelFromJson(jsonString);

import 'dart:convert';

AcceptResponseModel acceptResponseModelFromJson(String str) =>
    AcceptResponseModel.fromJson(json.decode(str));

String acceptResponseModelToJson(AcceptResponseModel data) =>
    json.encode(data.toJson());

class AcceptResponseModel {
  dynamic response;
  String message;
  String type;
  Data data;

  AcceptResponseModel({
    required this.response,
    required this.message,
    required this.type,
    required this.data,
  });

  factory AcceptResponseModel.fromJson(Map<String, dynamic> json) =>
      AcceptResponseModel(
        response: json["Response"],
        message: json["message"],
        type: json["type"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "data": data.toJson(),
      };
}

class Data {
  dynamic id;
  String? startCoordinate;
  String? endCoordinate;
  String? startAddress;
  String? endAddress;
  dynamic distance;
  dynamic paymentMethod;
  dynamic estimatedTime;
  dynamic actualTime;
  dynamic total;
  dynamic pendingAmount;
  dynamic driverId;
  String? name;
  dynamic profilePhoto;
  dynamic latitude;
  dynamic longitude;
  String? plateNumber;
  String? vehicleName;
  String? carModel;
  dynamic driverRating;
  dynamic phoneNumber;
  dynamic extraDistance;
  dynamic extraDistancePrice;
  dynamic extraTime;
  dynamic extraTimePrice;

  Data({
    required this.id,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.paymentMethod,
    required this.estimatedTime,
    required this.actualTime,
    required this.total,
    required this.pendingAmount,
    required this.driverId,
    required this.name,
    required this.profilePhoto,
    required this.latitude,
    required this.longitude,
    required this.plateNumber,
    required this.vehicleName,
    required this.carModel,
    required this.driverRating,
    this.phoneNumber,
    required this.extraDistance,
    required this.extraDistancePrice,
    required this.extraTime,
    required this.extraTimePrice,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        startAddress: json["start_address"] ?? '',
        endAddress: json["end_address"] ?? "",
        distance: json["distance"] ?? "",
        paymentMethod: json["payment_method"] ?? "",
        estimatedTime: json["estimated_time"] ?? "",
        actualTime: json["actual_time"] ?? "",
        total: json["total"] ?? "",
        pendingAmount: json["pending_amount"] ?? "",
        driverId: json["driverID"] ?? "",
        name: json["name"] ?? "",
        profilePhoto: json["profile_photo"] ?? "",
        latitude: json["Latitude"] ?? "",
        longitude: json["Longitude"] ?? "",
        plateNumber: json["plate_number"] ?? "",
        vehicleName: json["vehicle_name"] ?? "",
        carModel: json["car_model"] ?? "",
        driverRating: json["DriverRating"] ?? 0,
        phoneNumber: json["phone"] ?? "8547851456",
        extraDistance: json["extra_distance"] ?? "0",
        extraDistancePrice: json["extra_distance_price"] ?? '0',
        extraTime: json["extra_time"],
        extraTimePrice: json["extra_time_price"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "payment_method": paymentMethod,
        "estimated_time": estimatedTime,
        "actual_time": actualTime,
        "total": total,
        "pending_amount": pendingAmount,
        "driverID": driverId,
        "name": name,
        "profile_photo": profilePhoto,
        "Latitude": latitude,
        "Longitude": longitude,
        "plate_number": plateNumber,
        "vehicle_name": vehicleName,
        "car_model": carModel,
        "DriverRating": driverRating.toString(),
        "phoneNumber": phoneNumber,
        // "extra_distance": extraDistance,
        // "extra_distance_price": extraDistancePrice,
        // "extra_time": extraTime,
        // "extra_time_price": extraTimePrice,
      };
}
