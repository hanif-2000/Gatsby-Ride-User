import 'package:appkey_taxiapp_user/core/utility/injection.dart';
import 'package:appkey_taxiapp_user/core/utility/session_helper.dart';
import 'package:dio/dio.dart';

import '../models/register_response_model.dart';

abstract class RegisterDataSource {
  Future<RegisterResponseModel> doRegister(FormData formData);
}

class RegisterDataSourceImplementation implements RegisterDataSource {
  final Dio dio;

  RegisterDataSourceImplementation({required this.dio});

  @override
  Future<RegisterResponseModel> doRegister(FormData formData) async {
    String url = 'api/webservice/user_register';

    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = RegisterResponseModel.fromJson(response.data);
      final session = locator<Session>();
      if (model.token != '') {
        session.setToken = model.token!;
        return model;
      }
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
