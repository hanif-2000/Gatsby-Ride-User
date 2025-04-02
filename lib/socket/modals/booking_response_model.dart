// To parse this JSON data, do
//
//     final bookingDataModel = bookingDataModelFromJson(jsonString);

import 'dart:convert';

BookingDataModel bookingDataModelFromJson(String str) =>
    BookingDataModel.fromJson(json.decode(str));

String bookingDataModelToJson(BookingDataModel data) =>
    json.encode(data.toJson());

class BookingDataModel {
  dynamic response;
  String message;
  String type;
  Booking data;

  BookingDataModel({
    required this.response,
    required this.message,
    required this.type,
    required this.data,
  });

  factory BookingDataModel.fromJson(Map<String, dynamic> json) =>
      BookingDataModel(
        response: json["Response"].toString(),
        message: json["message"],
        type: json["type"],
        data: Booking.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "data": data.toJson(),
      };
}

class Booking {
  dynamic id;
  String startCoordinate;
  String endCoordinate;
  String startAddress;
  String endAddress;
  dynamic distance;
  dynamic paymentMethod;
  dynamic estimatedTime;
  dynamic actualTime;
  dynamic total;
  dynamic pendingAmount;
  dynamic newTotal;
  dynamic customerId;
  String name;
  String image;
  dynamic longitude;
  dynamic latitude;
  dynamic phone;
  dynamic customerRating;

  Booking({
    required this.id,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.paymentMethod,
    required this.estimatedTime,
    required this.actualTime,
    required this.total,
    required this.pendingAmount,
    required this.newTotal,
    required this.customerId,
    required this.name,
    required this.image,
    required this.longitude,
    required this.latitude,
    required this.phone,
    required this.customerRating,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        startCoordinate: json["start_coordinate"] ?? "",
        endCoordinate: json["end_coordinate"] ?? "",
        startAddress: json["start_address"] ?? "",
        endAddress: json["end_address"] ?? "",
        distance: json["distance"] ?? "",
        paymentMethod: json["payment_method"] ?? "",
        estimatedTime: json["estimated_time"] ?? "",
        actualTime: json["actual_time"] ?? "",
        total: json["total"] ?? "",
        pendingAmount: json["pending_amount"] ?? "",
        newTotal: json["new_total"] ?? "",
        customerId: json["customerID"] ?? "",
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        longitude: json["Longitude"] ?? "",
        latitude: json["Latitude"] ?? "",
        phone: json["phone"] ?? "",
        customerRating: json["CustomerRating"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_coordinate": startCoordinate,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "payment_method": paymentMethod,
        "estimated_time": estimatedTime,
        "actual_time": actualTime,
        "total": total,
        "pending_amount": pendingAmount,
        "new_total": newTotal,
        "customerID": customerId,
        "name": name,
        "image": image,
        "Longitude": longitude,
        "Latitude": latitude,
        "phone": phone,
        "CustomerRating": customerRating,
      };
}
