import '../../domain/entities/total_price.dart';

class TotalPriceModel extends TotalPrice {
  const TotalPriceModel({
    required String data,
  }) : super(
          data: data,
        );

  factory TotalPriceModel.fromJson(Map<String, dynamic> json) =>
      TotalPriceModel(
        data: json['message'].toString(),
      );
}
