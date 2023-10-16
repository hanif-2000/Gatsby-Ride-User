import 'package:equatable/equatable.dart';

class OrderReceiptResponseModel extends Equatable {
  final List<OrderReceiptDataModel>? orderReceipt;
  final int? success;

  const OrderReceiptResponseModel({
    this.success,
    this.orderReceipt,
  });

  @override
  List<Object?> get props => [success, orderReceipt];

  factory OrderReceiptResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderReceiptResponseModel(
        success: json["success"],
        orderReceipt: json["Order receipt"] == null
            ? []
            : List<OrderReceiptDataModel>.from(json["Order receipt"]
                .map((x) => OrderReceiptDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "orderReceipt":
            List<dynamic>.from(orderReceipt!.map((x) => x.toJson())),
      };

  // factory OrderReceiptResponseModel.fromJson(Map<String, dynamic> json) =>
  //     OrderReceiptResponseModel(
  //       orderReceipt: json['Order receipt'] == null
  //           ? null
  //           : OrderReceiptDataModel.fromJson(json['Order receipt']),
  //       success: json['success'] ?? 1,
  //     );
  // Map<String, dynamic> toJson() => {
  //       'orderReceipt': orderReceipt ?? null,
  //       // 'data': data == null ? '' : data!.toJson(),

  //       'success': success ?? '',
  //     };
}

// ignore: must_be_immutable
class OrderReceiptDataModel extends Equatable {
  String id;
  String driverId;
  String distance;
  dynamic total;
  String grandTotal;
  // String extraTime;
  // String extraKmPrice;
  String extraDistance;
  String extraDistancePrice;
  DateTime orderTime;
  dynamic startTime;
  dynamic endTime;
  String status;
  String image;
  String userName;
  String userPhone;
  int rating;
  String plateNumber;
  String vehicleName;
  String carModel;
  int paymentMethod;
  VehicleCategory vehicleCategory;
  String timestamp;

  OrderReceiptDataModel({
    required this.id,
    required this.driverId,
    required this.distance,
    required this.total,
    required this.orderTime,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.image,
    required this.userName,
    required this.userPhone,
    required this.rating,
    required this.plateNumber,
    required this.vehicleName,
    required this.carModel,
    required this.paymentMethod,
    required this.vehicleCategory,
    required this.timestamp,
    required this.grandTotal,
    // required this.extraTime,
    // required this.extraKmPrice,
    required this.extraDistance,
    required this.extraDistancePrice,
  });

  @override
  List<Object?> get props => [
        id,
        driverId,
        distance,
        total,
        orderTime,
        startTime,
        endTime,
        status,
        image,
        userName,
        userPhone,
        rating,
        paymentMethod,
        plateNumber,
        timestamp,
        vehicleName,
        vehicleCategory,
        carModel
      ];

  factory OrderReceiptDataModel.fromJson(Map<String, dynamic> json) =>
      OrderReceiptDataModel(
        id: json["id"] ?? "",
        driverId: json["driver_id"] ?? "",
        distance: json["distance"] ?? '',
        total: json["total"] ?? 0.0,
        orderTime: json["order_time"] != null
            ? DateTime.parse(json["order_time"])
            : DateTime.now(),
        startTime: json["start_time"] ?? DateTime.now().toIso8601String(),
        endTime: json["end_time"] ?? DateTime.now().toIso8601String(),
        status: json["status"] ?? '',
        image: json["image"],
        userName: json["user_name"] ?? "",
        userPhone: json["user_phone"] ?? '',
        rating: json["rating"] ?? 0,
        plateNumber: json["plate_number"] ?? '',
        vehicleName: json["vehicle_name"] ?? "",
        carModel: json["car_model"] ?? "",
        paymentMethod: json["payment_method"] ?? 1,
        vehicleCategory: VehicleCategory.fromJson(json["vehicle_category"]),
        timestamp: json["timestamp"],
        grandTotal: json["grand_total"] ?? '0',
        // extraTime: json["extra_time"] == "" ? "0" : json["extra_time"],
        // extraKmPrice:
        //     json["extra_km_price"].length == 0 ? "0" : json["extra_km_price"],
        extraDistance:
            json["extra_distance"].length == 1 ? "0" : json["extra_distance"],
        extraDistancePrice: json["extra_distance_price"] == ""
            ? '0'
            : json["extra_distance_price"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "distance": distance,
        "total": total,
        "order_time": orderTime.toIso8601String(),
        "start_time": startTime,
        "end_time": endTime,
        "status": status,
        "image": image,
        "user_name": userName,
        "user_phone": userPhone,
        "rating": rating,
        "plate_number": plateNumber,
        "vehicle_name": vehicleName,
        "car_model": carModel,
        "payment_method": paymentMethod,
        "vehicle_category": vehicleCategory.toJson(),
        "timestamp": timestamp,
        "grand_total": grandTotal,
        // "extra_time": extraTime,
        // "extra_km_price": extraKmPrice,
        "extra_distance": extraDistance,
        "extra_distance_price": extraDistancePrice,
      };
}

class VehicleCategory {
  int id;
  String category;
  double priceKm;
  dynamic techFee;
  dynamic baseFare;
  dynamic distance;
  double minKm;
  int minPrice;
  int extraKm;
  String seat;
  DateTime createdAt;
  DateTime updatedAt;
  // String deletedAt;

  VehicleCategory({
    required this.id,
    required this.category,
    required this.priceKm,
    required this.techFee,
    required this.baseFare,
    required this.distance,
    required this.minKm,
    required this.minPrice,
    required this.extraKm,
    required this.seat,
    required this.createdAt,
    required this.updatedAt,
    // required this.deletedAt,
  });

  factory VehicleCategory.fromJson(Map<String, dynamic> json) =>
      VehicleCategory(
        id: json["id"],
        category: json["category"],
        priceKm: json["price_km"]?.toDouble(),
        techFee: json["tech_fee"],
        baseFare: json["base_fare"],
        distance: json["distance"],
        minKm: json["min_km"]?.toDouble(),
        minPrice: json["min_price"],
        extraKm: json["extra_km"],
        seat: json["seat"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        // deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "price_km": priceKm,
        "tech_fee": techFee,
        "base_fare": baseFare,
        "distance": distance,
        "min_km": minKm,
        "min_price": minPrice,
        "extra_km": extraKm,
        "seat": seat,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        // "deleted_at": deletedAt,
      };
}


// class VehicleCategory {
//   int id;
//   String category;
//   int priceKm;
//   int distance;
//   int minKm;
//   int minPrice;
//   int extraKm;
//   int seat;
//   DateTime createdAt;
//   DateTime updatedAt;
//   dynamic deletedAt;

//   VehicleCategory({
//     required this.id,
//     required this.category,
//     required this.priceKm,
//     required this.distance,
//     required this.minKm,
//     required this.minPrice,
//     required this.extraKm,
//     required this.seat,
//     required this.createdAt,
//     required this.updatedAt,
//     this.deletedAt,
//   });

//   factory VehicleCategory.fromJson(Map<String, dynamic> json) =>
//       VehicleCategory(
//         id: json["id"],
//         category: json["category"],
//         priceKm: json["price_km"],
//         distance: json["distance"],
//         minKm: json["min_km"],
//         minPrice: json["min_price"],
//         extraKm: json["extra_km"],
//         seat: json["seat"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         deletedAt: json["deleted_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "category": category,
//         "price_km": priceKm,
//         "distance": distance,
//         "min_km": minKm,
//         "min_price": minPrice,
//         "extra_km": extraKm,
//         "seat": seat,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "deleted_at": deletedAt,
//       };
// }
