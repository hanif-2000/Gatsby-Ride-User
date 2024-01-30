// // To parse this JSON data, do
// //
// //     final getOrderDetailsResponseModel = getOrderDetailsResponseModelFromJson(jsonString);

// import 'dart:convert';

// GetOrderDetailsResponseModel getOrderDetailsResponseModelFromJson(String str) =>
//     GetOrderDetailsResponseModel.fromJson(json.decode(str));

// String getOrderDetailsResponseModelToJson(GetOrderDetailsResponseModel data) =>
//     json.encode(data.toJson());

// class GetOrderDetailsResponseModel {
//   dynamic success;
//   Order order;

//   GetOrderDetailsResponseModel({
//     required this.success,
//     required this.order,
//   });

//   factory GetOrderDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
//       GetOrderDetailsResponseModel(
//         success: json["success"],
//         order: Order.fromJson(json["order"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "order": order.toJson(),
//       };
// }

// class Order {
//   dynamic id;
//   dynamic driverId;
//   dynamic customerId;
//   dynamic total;
//   dynamic orderStatus;
//   String startCoordinate;
//   String endCoordinate;
//   String startAddress;
//   String endAddress;
//   String distance;
//   String pendingAmount;
//   dynamic newTotal;

//   Order({
//     required this.id,
//     required this.driverId,
//     required this.customerId,
//     required this.total,
//     required this.orderStatus,
//     required this.startCoordinate,
//     required this.endCoordinate,
//     required this.startAddress,
//     required this.endAddress,
//     required this.distance,
//     required this.pendingAmount,
//     required this.newTotal,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//         id: json["id"] ?? '',
//         driverId: json["driver_id"] ?? '',
//         customerId: json["customer_id"] ?? "",
//         total: json["total"] ?? "",
//         orderStatus: json["order_status"] ?? "",
//         startCoordinate: json["start_coordinate"] ?? "",
//         endCoordinate: json["end_coordinate"] ?? '',
//         startAddress: json["start_address"] ?? "",
//         endAddress: json["end_address"] ?? "",
//         distance: json["distance"] ?? "",
//         pendingAmount: json["pending_amount"] ?? '',
//         newTotal: json["new_total"] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "driver_id": driverId,
//         "customer_id": customerId,
//         "total": total,
//         "order_status": orderStatus,
//         "start_coordinate": startCoordinate,
//         "end_coordinate": endCoordinate,
//         "start_address": startAddress,
//         "end_address": endAddress,
//         "distance": distance,
//         "pending_amount": pendingAmount,
//         "new_total": newTotal,
//       };
// }
