import 'package:equatable/equatable.dart';

import 'order_detail.dart';

class OrderDetailResponse extends Equatable {
  final int success;
  final OrderDetail data;

  const OrderDetailResponse({
    required this.success,
    required this.data,
  });

  @override
  List<Object?> get props => [
        success,
        data,
      ];

  Map<String, dynamic> toJson() => {};
}
