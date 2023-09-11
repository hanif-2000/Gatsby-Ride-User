// To parse this JSON data, do
//
//     final historyResponseModel = historyResponseModelFromJson(jsonString);

import 'dart:convert';

HistoryResponseModel historyResponseModelFromJson(String str) =>
    HistoryResponseModel.fromJson(json.decode(str));

String historyResponseModelToJson(HistoryResponseModel data) =>
    json.encode(data.toJson());

class HistoryResponseModel {
  HistoryResponseModel({
    required this.success,
    required this.historyOrder,
  });

  int success;
  List<HistoryOrder> historyOrder;

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      HistoryResponseModel(
        success: json["success"],
        historyOrder: List<HistoryOrder>.from(
            json["history_order"].map((x) => HistoryOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "history_order":
            List<dynamic>.from(historyOrder.map((x) => x.toJson())),
      };
}

class HistoryOrder {
  HistoryOrder({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.image,
    required this.plateNumber,
    required this.rating,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.total,
    required this.orderTime,
    required this.status,
    required this.paymentMethod,
    required this.taxiType,
    required this.timestamp,
    required this.category,
    required this.ratingList,
  });

  String id;
  String driverId;
  String driverName;
  String image;
  dynamic rating;
  String plateNumber;
  String startCoordinate;
  String endCoordinate;
  String startAddress;
  String endAddress;
  String distance;
  String total;
  DateTime orderTime;
  int status;

  String paymentMethod;
  String taxiType;
  String timestamp;
  CategoryClass category;
  List<RatingList> ratingList;

  factory HistoryOrder.fromJson(Map<String, dynamic> json) => HistoryOrder(
        id: json["id"] ?? '',
        driverId: json["driver_id"] ?? "",
        driverName: json["driver_name"] ?? '',
        image: json["image"] ?? '',
        plateNumber: json["plate_number"] ?? '',
        rating: json["rating"] ?? '',
        startCoordinate: json["start_coordinate"] ?? "",
        endCoordinate: json["end_coordinate"] ?? "",
        startAddress: json["start_address"] ?? '',
        endAddress: json["end_address"] ?? "",
        distance: json["distance"] ?? "",
        total: json["total"] ?? '',
        orderTime: DateTime.parse(json["order_time"]),
        status: json["status"] ?? 0,
        paymentMethod: json["payment_method"] ?? "1",
        taxiType: json["taxi_type"] ?? '',
        timestamp: json["timestamp"],
        category: CategoryClass.fromJson(json["category"]),
        ratingList: List<RatingList>.from(
            json["rating_list"].map((x) => RatingList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "driver_name": driverName,
        "image": image,
        "plate_number": plateNumber,
        "rating": rating,
        "start_coordinate": startCoordinate,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "total": total,
        "order_time": orderTime,
        "status": status,
        "payment_method": paymentMethod,
        "taxi_type": taxiType,
        "timestamp": timestamp,
        "category": category.toJson(),
        "rating_list": List<dynamic>.from(ratingList.map((x) => x.toJson())),
      };
}

class CategoryClass {
  CategoryClass({
    required this.id,
    required this.category,
    required this.priceKm,
    required this.distance,
    required this.minKm,
    required this.minPrice,
    required this.extraKm,
    required this.seat,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  int id;
  String category;
  int priceKm;
  int distance;
  int minKm;
  int minPrice;
  int extraKm;
  int seat;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory CategoryClass.fromJson(Map<String, dynamic> json) => CategoryClass(
        id: json["id"],
        category: json["category"],
        priceKm: json["price_km"] ?? 0,
        distance: json["distance"],
        minKm: json["min_km"],
        minPrice: json["min_price"],
        extraKm: json["extra_km"],
        seat: json["seat"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "price_km": priceKm,
        "distance": distance,
        "min_km": minKm,
        "min_price": minPrice,
        "extra_km": extraKm,
        "seat": seat,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class RatingList {
  int id;
  int senderId;
  int receiverId;
  int orderId;
  String rating;
  String review;
  int type;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  RatingList({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.orderId,
    required this.rating,
    required this.review,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RatingList.fromJson(Map<String, dynamic> json) => RatingList(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        orderId: json["order_id"],
        rating: json["rating"],
        review: json["review"],
        type: json["type"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "order_id": orderId,
        "rating": rating,
        "review": review,
        "type": type,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
