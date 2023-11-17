import 'package:GetsbyRideshare/core/data/models/price_category_model.dart';
import 'package:GetsbyRideshare/core/domain/entities/price_category.dart';
import 'package:GetsbyRideshare/core/domain/entities/price_category_list.dart';

class PriceCategoryListModel extends PriceCategoryList {
  const PriceCategoryListModel({
    required bool success,
    required List<PriceCategory> data,
  }) : super(
          success: success,
          data: data,
        );

  factory PriceCategoryListModel.fromJson(Map<String, dynamic> json) =>
      PriceCategoryListModel(
          success: json['success'],
          data: List<PriceCategoryModel>.from(
              json['data'].map((x) => PriceCategoryModel.fromJson(x))));
  @override
  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.map((e) => e.toJson()),
      };
}
