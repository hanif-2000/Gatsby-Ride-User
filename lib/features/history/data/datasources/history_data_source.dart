import 'package:appkey_taxiapp_user/core/utility/extension.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:dio/dio.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../models/history_response_model.dart';

abstract class HistoryDataSource {
  Future<List<HistoryOrder>> getHistory();
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
}
