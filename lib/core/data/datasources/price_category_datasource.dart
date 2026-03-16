import 'dart:developer';

import 'package:GetsbyRideshare/core/domain/entities/price_category_list.dart';
import 'package:dio/dio.dart';

import '../models/price_category_list_model.dart';

abstract class PriceCategoryDataSource {
  Future<PriceCategoryList> getPriceCategoryList(
    String distance,
    String nightService,
    String coordinates,
    String estimatedTime,
  );
}

class PriceCategoryDataSourceImplementation implements PriceCategoryDataSource {
  final Dio dio;

  PriceCategoryDataSourceImplementation({required this.dio});

  @override
  Future<PriceCategoryList> getPriceCategoryList(
    String distance,
    String nightService,
    String coordinates,
    String estimatedTime,
  ) async {
    FormData data = FormData.fromMap({
      'distance': distance,
      'night_service': nightService,
      'coordinates': coordinates,
      'estimated_time': estimatedTime,
    });
    String url = 'api/webservice/priceCategory';

    try {
      final response = await dio.post(
        url,
        data: data,
      );

      log("bikbbu-price" + response.data.toString());
      log("=== PRICE CATEGORY PARSING ===");
      return PriceCategoryListModel.fromJson(response.data);
    } catch (e) {
      log("PriceCategoryListModel detail Error PriceCategoryDataSourceImplementation : ",
          error: e);
      rethrow;
    }
  }
}