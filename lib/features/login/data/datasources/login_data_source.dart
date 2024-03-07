import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../models/login_response_model.dart';

abstract class LoginDataSource {
  Future<LoginResponseModel?> doLogin(
    String email,
    String password,
    String loginType,
    String deviceType,
  );

  Future<LoginResponseModel?> doLoginSocial(
    String email,
    String firstName,
    String lastName,
    String loginType,
    String deviceType,
    String socialId,
  );
}

class LoginDataSourceImplementation implements LoginDataSource {
  final Dio dio;

  LoginDataSourceImplementation({required this.dio});

  @override
  Future<LoginResponseModel?> doLogin(
    String email,
    String password,
    String loginType,
    String deviceType,
  ) async {
    String url = 'api/webservice/login';
    final deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
    log("fcm token : " + deviceToken.toString());
    FormData data = FormData.fromMap({
      'email': email,
      'password': password,
      'fcm_token': deviceToken,
      'login_type': loginType,
      'device_type': deviceType
    });

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
        session.setChatToken = model.data!.chatToken!;
        return model;
      } else {
        return model;
      }
    } catch (e) {
      rethrow;
    }
  }

  //Social Login

  @override
  Future<LoginResponseModel?> doLoginSocial(
    String email,
    String firstName,
    String lastName,
    String loginType,
    String deviceType,
    String socialId,
  ) async {
    String url = 'api/webservice/login';
    final deviceToken = await FirebaseMessaging.instance.getToken() ?? "";

    log("device token:  $deviceToken");
    FormData data = FormData.fromMap({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'fcm_token': deviceToken,
      'login_type': 'social',
      'device_type': Platform.isAndroid ? "android" : "ios",
      'country': 'Canada',
      "social_id": socialId,
    });

    log("----Social login ----> ${data.fields}");

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
        session.setChatToken = model.data!.chatToken!;
        return model;
      } else {
        return model;
      }
    } catch (e) {
      rethrow;
    }
  }
}
