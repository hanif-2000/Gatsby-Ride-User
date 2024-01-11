import 'dart:developer';

import 'package:GetsbyRideshare/features/login/data/models/login_response_model.dart';
import 'package:dio/dio.dart';
import 'package:GetsbyRideshare/core/data/models/currency_model.dart';

abstract class LogoutDataSource {
  Future<LoginResponseModel> logOutUser();
}

class LogoutDataSourceImplementation implements LogoutDataSource {
  final Dio dio;

  LogoutDataSourceImplementation({required this.dio});

  @override
  Future<LoginResponseModel> logOutUser() async {
    // String path = 'api/webservice/currency';
    String path = "https://php.parastechnologies.in/taxi/public/api/webservice/logout";

    try {
      final response = await dio.get(path);
      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      log("logOutUser Error LogoutDataSourceImplementation : ",
          error: e);
      rethrow;
    }
  }
}
