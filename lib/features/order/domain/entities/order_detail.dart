import 'package:equatable/equatable.dart';

class OrderDetail extends Equatable {
  final int orderId, userId, driverId, totalPrice;
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

  toJson() {}

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
