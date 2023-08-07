import 'dart:developer';

import 'package:GetsbyRideshare/core/data/models/total_price_model.dart';
import 'package:dio/dio.dart';

abstract class TotalPriceDataSource {
  Future<TotalPriceModel> getTotalPrice(
      String kategoriId, String distance, String night);
}

class TotalPriceDataSourceImplementation implements TotalPriceDataSource {
  final Dio dio;

  TotalPriceDataSourceImplementation({required this.dio});

  @override
  Future<TotalPriceModel> getTotalPrice(
      String kategoriId, String distance, String night) async {
    String path =
        'api/webservice/total-price-order?vehicle_category_id=$kategoriId&distance=$distance&night_service=$night';

    log(path.toString());

    try {
      final response = await dio.get(path);
      return TotalPriceModel.fromJson(response.data);
    } catch (e) {
      log("Total price detail Error TotalPriceDataSourceImplementation : ",
          error: e);
      rethrow;
    }
  }
}
