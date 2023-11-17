import 'package:GetsbyRideshare/core/data/models/vehicles_category_modal.dart';
import 'package:GetsbyRideshare/core/domain/entities/vehicles_category.dart';

import '../../domain/entities/vehcles_category_list.dart';

class VehiclesCategoryListModel extends VehiclesCategoryList {
  const VehiclesCategoryListModel({
    required bool success,
    required List<VehiclesCategory> data,
  }) : super(
          success: success,
          data: data,
        );

  factory VehiclesCategoryListModel.fromJson(Map<String, dynamic> json) =>
      VehiclesCategoryListModel(
        success: json['success'],
        data: List<VehiclesCategoryModel>.from(
          json['data'].map(
            (x) => VehiclesCategoryModel.fromJson(x),
          ),
        ),
      );
  @override
  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.map(
          (e) => e.toJson(),
        ),
      };
}
