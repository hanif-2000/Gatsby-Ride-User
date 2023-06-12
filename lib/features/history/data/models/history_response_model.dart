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
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.total,
    required this.orderTime,
    required this.status,
    required this.timeSchool,
    required this.timeAfterSchool,
    required this.paymentMethod,
    required this.taxiType,
    required this.timestamp,
    required this.category,
  });

  String id;
  String driverId;
  String startCoordinate;
  String endCoordinate;
  String startAddress;
  String endAddress;
  String distance;
  String total;
  DateTime orderTime;
  int status;
  String timeSchool;
  String timeAfterSchool;
  String paymentMethod;
  String taxiType;
  String timestamp;
  CategoryClass category;

  factory HistoryOrder.fromJson(Map<String, dynamic> json) => HistoryOrder(
        id: json["id"],
        driverId: json["driver_id"],
        startCoordinate: json["start_coordinate"],
        endCoordinate: json["end_coordinate"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        distance: json["distance"],
        total: json["total"],
        orderTime: DateTime.parse(json["order_time"]),
        status: json["status"],
        timeSchool: json["time_school"],
        timeAfterSchool: json["time_after_school"],
        paymentMethod: json["payment_method"],
        taxiType: json["taxi_type"],
        timestamp: json["timestamp"],
        category: CategoryClass.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "start_coordinate": startCoordinate,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "total": total,
        "order_time": orderTime.toIso8601String(),
        "status": status,
        "time_school": timeSchool,
        "time_after_school": timeAfterSchool,
        "payment_method": paymentMethod,
        "taxi_type": taxiType,
        "timestamp": timestamp,
        "category": category.toJson(),
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
        priceKm: json["price_km"],
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
