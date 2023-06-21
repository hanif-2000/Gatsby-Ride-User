import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../models/login_response_model.dart';

abstract class LoginDataSource {
  Future<LoginResponseModel?> doLogin(String email, String password);
}

class LoginDataSourceImplementation implements LoginDataSource {
  final Dio dio;

  LoginDataSourceImplementation({required this.dio});

  @override
  Future<LoginResponseModel?> doLogin(String email, String password) async {
    String url = 'api/webservice/login';
    final session = locator<Session>();
    String fcmToken = session.sessionFcmToken;
    FormData data = FormData.fromMap(
        {'email': email, 'password': password, 'fcm_token': fcmToken});

    try {
      final response = await dio.post(
        url,
        data: data,
      );
      final model = LoginResponseModel.fromJson(response.data);
      final session = locator<Session>();

      log("response" + response.data.toString());

      if (model.data != null) {
        session.setUserId = model.data!.userId.toString();
        session.setToken = model.token!;
        return model;
      } else {
        return model;
      }
    } catch (e) {
      rethrow;
    }
  }
}
