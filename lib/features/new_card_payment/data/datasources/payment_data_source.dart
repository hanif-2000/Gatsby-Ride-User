import 'package:GetsbyRideshare/core/utility/extension.dart';
import 'package:dio/dio.dart';

import '../models/add_card_response_modal.dart';
import '../models/card_list_response_modal.dart';

abstract class PaymentDataSource {
  Future<CardListResponseModal> getCardDetails();
  Future<AddCardResponseModal> addCardDetails(FormData formData);
}

class PaymentDataSourceImplementation implements PaymentDataSource {
  final Dio dio;

  PaymentDataSourceImplementation({required this.dio});

//Get Profile data with bearer token
  @override
  Future<CardListResponseModal> getCardDetails() async {
    String url = 'api/webservice/card/list';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
      );
      final model = CardListResponseModal.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AddCardResponseModal> addCardDetails(FormData formData) async {
    String url = "api/webservice/card/detail/add";
    dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = AddCardResponseModal.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
