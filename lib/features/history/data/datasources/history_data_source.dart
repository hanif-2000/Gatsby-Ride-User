import 'dart:developer';

import 'package:GetsbyRideshare/core/utility/extension.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:dio/dio.dart';

import '../models/history_response_model.dart';
import '../models/rating_response_modal.dart';

abstract class HistoryDataSource {
  Future<List<HistoryOrder>> getHistory();

  Future<GetRatingResponseModal> getRatings(FormData formData);
}

class HistoryDataSourceImplementation implements HistoryDataSource {
  final Dio dio;

  HistoryDataSourceImplementation({required this.dio});

  @override
  Future<List<HistoryOrder>> getHistory() async {
    String url = 'api/webservice/history_order_user';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = HistoryResponseModel.fromJson(response.data);
      logMe("Loaded modell");
      return model.historyOrder;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GetRatingResponseModal> getRatings(FormData formData) async {
    log(formData.fields.toString());
    String url = 'api/webservice/rating/list';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = GetRatingResponseModal.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
