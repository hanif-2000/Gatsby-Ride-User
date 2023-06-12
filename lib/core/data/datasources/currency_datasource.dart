import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/currency_model.dart';

abstract class CurrencyDataSource {
  Future<CurrencyModel> getCurrency();
}

class CurrencyDataSourceImplementation implements CurrencyDataSource {
  final Dio dio;

  CurrencyDataSourceImplementation({required this.dio});

  @override
  Future<CurrencyModel> getCurrency() async {
    // String path = 'api/webservice/currency';
    String path =
        "https://php.parastechnologies.in/taxi/public/api/webservice/currency";

    try {
      final response = await dio.get(path);
      return CurrencyModel.fromJson(response.data);
    } catch (e) {
      log("Currency detail Error CurrencyDataSourceImplementation : ",
          error: e);
      rethrow;
    }
  }
}
