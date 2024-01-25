// To parse this JSON data, do
//
//     final newReceiptModel = newReceiptModelFromJson(jsonString);

import 'dart:convert';

NewReceiptModel newReceiptModelFromJson(String str) =>
    NewReceiptModel.fromJson(json.decode(str));

String newReceiptModelToJson(NewReceiptModel data) =>
    json.encode(data.toJson());

class NewReceiptModel {
  dynamic response;
  String message;
  String type;
  int orderId;
  ReceiptData data;

  NewReceiptModel({
    required this.response,
    required this.message,
    required this.type,
    required this.orderId,
    required this.data,
  });

  factory NewReceiptModel.fromJson(Map<String, dynamic> json) =>
      NewReceiptModel(
        response: json["Response"],
        message: json["message"],
        type: json["type"],
        orderId: json["OrderID"],
        data: ReceiptData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "OrderID": orderId,
        "data": data.toJson(),
      };
}

class ReceiptData {
  dynamic id;
  String startAddress;
  String endAddress;
  dynamic distance;
  dynamic paymentMethod;
  dynamic estimatedTime;
  dynamic actualTime;
  DateTime createdAt;
  dynamic total;
  dynamic pendingAmount;
  dynamic driverId;
  String carModel;
  dynamic insuranceNumber;
  String name;
  String image;
  dynamic longitude;
  dynamic latitude;
  dynamic phone;
  String plateNumber;
  String vehicleName;
  dynamic driverRating;
  dynamic extraDistance;
  dynamic extraDistancePrice;
  String extraTime;
  dynamic extraTimePrice;

  ReceiptData({
    required this.id,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.paymentMethod,
    required this.estimatedTime,
    required this.actualTime,
    required this.createdAt,
    required this.total,
    required this.pendingAmount,
    required this.driverId,
    required this.carModel,
    required this.insuranceNumber,
    required this.name,
    required this.image,
    required this.longitude,
    required this.latitude,
    required this.phone,
    required this.plateNumber,
    required this.vehicleName,
    required this.driverRating,
    required this.extraDistance,
    required this.extraDistancePrice,
    required this.extraTime,
    required this.extraTimePrice,
  });

  factory ReceiptData.fromJson(Map<String, dynamic> json) => ReceiptData(
        id: json["id"] ?? '',
        startAddress: json["start_address"] ?? '',
        endAddress: json["end_address"],
        distance: json["distance"] ?? '',
        paymentMethod: json["payment_method"],
        estimatedTime: json["estimated_time"] ?? "",
        actualTime: json["actual_time"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        total: json["total"] ?? "",
        pendingAmount: json["pending_amount"] ?? "",
        driverId: json["driverID"] ?? "",
        carModel: json["car_model"] ?? "",
        insuranceNumber: json["insurance_number"] ?? "",
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        longitude: json["Longitude"] ?? "",
        latitude: json["Latitude"] ?? "",
        phone: json["phone"] ?? "",
        plateNumber: json["plate_number"] ?? "",
        vehicleName: json["vehicle_name"] ?? "",
        driverRating: json["DriverRating"] ?? "",
        extraDistance: json["extra_distance"] ?? "",
        extraDistancePrice: json["extra_distance_price"] ?? "",
        extraTime: json["extra_time"] ?? "",
        extraTimePrice: json["extra_time_price"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "payment_method": paymentMethod,
        "estimated_time": estimatedTime,
        "actual_time": actualTime,
        "created_at": createdAt.toIso8601String(),
        "total": total,
        "pending_amount": pendingAmount,
        "driverID": driverId,
        "car_model": carModel,
        "insurance_number": insuranceNumber,
        "name": name,
        "image": image,
        "Longitude": longitude,
        "Latitude": latitude,
        "phone": phone,
        "plate_number": plateNumber,
        "vehicle_name": vehicleName,
        "DriverRating": driverRating,
        "extra_distance": extraDistance,
        "extra_distance_price": extraDistancePrice,
        "extra_time": extraTime,
        "extra_time_price": extraTimePrice,
      };
}
