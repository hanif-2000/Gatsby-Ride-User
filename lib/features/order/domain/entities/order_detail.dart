import 'package:equatable/equatable.dart';

class OrderDetail extends Equatable {
  final dynamic totalPrice, driverId;
  final dynamic orderId, userId;

  final String startCoordinate,
      endCoordinate,
      distance,
      startAddress,
      endAddress;

  const OrderDetail({
    required this.orderId,
    required this.totalPrice,
    required this.userId,
    required this.driverId,
    required this.distance,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
  });

  // Factory method to create an OrderDetail instance from a Map (JSON)
  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderId: json['orderId'],
      totalPrice: json['totalPrice'],
      userId: json['userId'],
      driverId: json['driverId'],
      distance: json['distance'],
      startCoordinate: json['startCoordinate'],
      endCoordinate: json['endCoordinate'],
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
    );
  }

  // Convert OrderDetail instance to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'totalPrice': totalPrice,
      'userId': userId,
      'driverId': driverId,
      'distance': distance,
      'startCoordinate': startCoordinate,
      'endCoordinate': endCoordinate,
      'startAddress': startAddress,
      'endAddress': endAddress,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        orderId,
        totalPrice,
        userId,
        distance,
        driverId,
        startCoordinate,
        endCoordinate,
        startAddress,
        endAddress
      ];
}
