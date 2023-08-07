import 'package:GetsbyRideshare/features/order/data/models/driver_detail_model.dart';
import 'package:GetsbyRideshare/features/order/domain/entities/driver_detail.dart';

import '../../domain/entities/driver_detail_response.dart';

class DriverDetailResponseModel extends DriverDetailResponse {
  const DriverDetailResponseModel({
    required int success,
    required DriverDetail data,
  }) : super(
          success: success,
          data: data,
        );

  factory DriverDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      DriverDetailResponseModel(
        success: json['success'],
        data: DriverDetailModel.fromJson(json["message"]),
      );
  @override
  Map<String, dynamic> toJson() => {
        'success': success,
        'message': data.toJson(),
      };
}
