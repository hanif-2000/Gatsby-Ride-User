import 'package:GetsbyRideshare/features/order/domain/entities/order_detail.dart';
import 'package:GetsbyRideshare/features/order/domain/entities/order_detail_response.dart';

import 'detail_order_model.dart';

class OrderDetailResponseModel extends OrderDetailResponse {
  const OrderDetailResponseModel({
    required int success,
    required OrderDetail data,
  }) : super(
          success: success,
          data: data,
        );

  factory OrderDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponseModel(
          success: json['success'],
          data: DetailOrderModel.fromJson(json["order"]));
  @override
  Map<String, dynamic> toJson() => {
        'success': success,
        'order': data.toJson(),
      };
}
