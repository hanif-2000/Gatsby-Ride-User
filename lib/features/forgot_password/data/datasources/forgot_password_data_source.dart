import 'package:GetsbyRideshare/features/forgot_password/data/models/forgot_password_response_model.dart';
import 'package:dio/dio.dart';

abstract class ForgotPasswordDataSource {
  Future<ForgotPasswordResponseModel> doForgotPassword(FormData formData);
  Future<ForgotPasswordResponseModel> updatePassword(FormData formData);
  Future<ForgotPasswordResponseModel> verifyOtp(FormData formData);
}

class ForgotPasswordDataSourceImplementation
    implements ForgotPasswordDataSource {
  final Dio dio;

  ForgotPasswordDataSourceImplementation({required this.dio});

  @override
  Future<ForgotPasswordResponseModel> doForgotPassword(
      FormData formData) async {
    String url = 'api/webservice/password/forgot';
    // String url = 'api/webservice/reset-password-user';

    // String url = 'api/webservice/customer/password/reset';

    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = ForgotPasswordResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ForgotPasswordResponseModel> updatePassword(FormData formData) async {
    String url = 'api/webservice/customer/password/reset';
    // dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = ForgotPasswordResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ForgotPasswordResponseModel> verifyOtp(FormData formData) async {
    String url = 'api/webservice/otp/verify';
    // dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = ForgotPasswordResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
