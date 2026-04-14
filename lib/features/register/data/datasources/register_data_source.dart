import 'dart:developer';

import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
import 'package:dio/dio.dart';

import '../models/register_response_model.dart';

abstract class RegisterDataSource {
  Future<RegisterResponseModel> doRegister(Map<String, dynamic> data);
}

class RegisterDataSourceImplementation implements RegisterDataSource {
  final Dio dio;

  RegisterDataSourceImplementation({required this.dio});

  @override
  Future<RegisterResponseModel> doRegister(Map<String, dynamic> data) async {
    String url = 'api/webservice/user_register';

    try {
      final response = await dio.post(url, data: data);
      log("user register data is:-->> $data");
      final model = RegisterResponseModel.fromJson(response.data);
      final session = locator<Session>();
      if (model.token != '') {
        session.setToken = model.token!;
        session.setUserId = model.userId.toString();
        session.setChatToken = model.chatToken;
        return model;
      }

      return model;
    } catch (e) {
      rethrow;
    }
  }
}
