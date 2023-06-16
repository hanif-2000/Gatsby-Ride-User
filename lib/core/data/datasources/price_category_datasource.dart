import 'dart:developer';

import 'package:appkey_taxiapp_user/core/domain/entities/price_category_list.dart';
import 'package:dio/dio.dart';

import '../models/price_category_list_model.dart';

abstract class PriceCategoryDataSource {
  Future<PriceCategoryList> getPriceCategoryList(
    String distance,
    String nightService,
    String coordinates,
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
  ) async {
    FormData data = FormData.fromMap({
      'distance': distance,
      'night_service': nightService,
      'coordinates': coordinates
    });
    String url = 'api/webservice/priceCategory';

    try {
      // final response = await dio.post(path,data: formdata);
      final response = await dio.post(
        url,
        data: data,
      );

      log("bikbbu" + response.data.toString());
      return PriceCategoryListModel.fromJson(response.data);
      // return VehicleCategoryModal.fromJson(response.data);
    } catch (e) {
      log("PriceCategoryListModel detail Error PriceCategoryDataSourceImplementation : ",
          error: e);
      rethrow;
    }
  }
}
