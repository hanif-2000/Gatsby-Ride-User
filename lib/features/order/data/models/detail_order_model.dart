import 'package:appkey_taxiapp_user/features/order/domain/entities/order_detail.dart';

class DetailOrderModel extends OrderDetail {
  const DetailOrderModel({
    required int orderId,
    required int driverId,
    required int userId,
    required int totalPrice,
    required String startCoordinate,
    required String endCoordinate,
    required String startAddress,
    required String endAddress,
    required String distance,
  }) : super(
          orderId: orderId,
          driverId: driverId,
          userId: userId,
          distance: distance,
          totalPrice: totalPrice,
          startCoordinate: startCoordinate,
          startAddress: startAddress,
          endAddress: endAddress,
          endCoordinate: endCoordinate,
        );

  factory DetailOrderModel.fromJson(Map<String, dynamic> json) =>
      DetailOrderModel(
        orderId: json['id'],
        driverId: json['driver_id'] ?? 0,
        userId: json['customer_id'],
        distance: json['distance'],
        totalPrice: json['total'],
        startCoordinate: json['start_coordinate'],
        endAddress: json['end_address'],
        startAddress: json['start_address'],
        endCoordinate: json['end_coordinate'],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": orderId,
        "driver_id": driverId,
        "customer_id": userId,
        "distance": distance,
        "total": totalPrice,
        "start_coordinate": startCoordinate,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "end_address": endAddress,
      };
}
