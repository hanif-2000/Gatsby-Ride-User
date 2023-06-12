import 'package:appkey_taxiapp_user/core/domain/entities/price_category.dart';
import 'package:equatable/equatable.dart';

class PriceCategoryList extends Equatable {
  final bool success;
  final List<PriceCategory> data;

  const PriceCategoryList({
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
