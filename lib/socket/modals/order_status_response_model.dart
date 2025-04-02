// To parse this JSON data, do
//
//     final orderStatusResponseModel = orderStatusResponseModelFromJson(jsonString);

import 'dart:convert';

OrderStatusResponseModel orderStatusResponseModelFromJson(String str) =>
    OrderStatusResponseModel.fromJson(json.decode(str));

String orderStatusResponseModelToJson(OrderStatusResponseModel data) =>
    json.encode(data.toJson());

class OrderStatusResponseModel {
  bool response;
  String message;
  String type;
  int orderId;
  Data data;

  OrderStatusResponseModel({
    required this.response,
    required this.message,
    required this.type,
    required this.orderId,
    required this.data,
  });

  factory OrderStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderStatusResponseModel(
        response: json["Response"],
        message: json["message"],
        type: json["type"],
        orderId: json["OrderID"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "OrderID": orderId,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String startAddress;
  String endAddress;
  double distance;
  int paymentMethod;
  double estimatedTime;
  int actualTime;
  double total;
  int pendingAmount;
  int driverId;
  String carModel;
  int insuranceNumber;
  String name;
  String image;
  double longitude;
  double latitude;
  int phone;
  String plateNumber;
  String vehicleName;
  int driverRating;

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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        distance: json["distance"]?.toDouble(),
        paymentMethod: json["payment_method"],
        estimatedTime: json["estimated_time"]?.toDouble(),
        actualTime: json["actual_time"],
        total: json["total"]?.toDouble(),
        pendingAmount: json["pending_amount"],
        driverId: json["driverID"],
        carModel: json["car_model"],
        insuranceNumber: json["insurance_number"],
        name: json["name"],
        image: json["image"],
        longitude: json["Longitude"]?.toDouble(),
        latitude: json["Latitude"]?.toDouble(),
        phone: json["phone"],
        plateNumber: json["plate_number"],
        vehicleName: json["vehicle_name"],
        driverRating: json["DriverRating"],
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
      };
}
