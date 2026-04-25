import 'package:GetsbyRideshare/features/forgot_password/data/models/forgot_password_response_model.dart';
import 'package:dio/dio.dart';

abstract class ForgotPasswordDataSource {
  Future<ForgotPasswordResponseModel> doForgotPassword(Map<String, dynamic> data);
  Future<ForgotPasswordResponseModel> updatePassword(Map<String, dynamic> data);
  Future<ForgotPasswordResponseModel> verifyOtp(Map<String, dynamic> data);
}

class ForgotPasswordDataSourceImplementation
    implements ForgotPasswordDataSource {
  final Dio dio;

  ForgotPasswordDataSourceImplementation({required this.dio});

  @override
  Future<ForgotPasswordResponseModel> doForgotPassword(
      Map<String, dynamic> data) async {
    String url = 'api/webservice/password/forgot';
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'content-type': 'application/json'}),
      );
      final model = ForgotPasswordResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ForgotPasswordResponseModel> updatePassword(
      Map<String, dynamic> data) async {
    String url = 'api/webservice/customer/password/reset';
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'content-type': 'application/json'}),
      );
      final model = ForgotPasswordResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ForgotPasswordResponseModel> verifyOtp(
      Map<String, dynamic> data) async {
    String url = 'api/webservice/otp/verify';
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'content-type': 'application/json'}),
      );
      final model = ForgotPasswordResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
