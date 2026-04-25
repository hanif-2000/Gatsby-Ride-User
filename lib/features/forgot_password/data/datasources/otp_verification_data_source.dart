import 'package:dio/dio.dart';

import '../../data/models/otp_verification_response_modal.dart';

abstract class OtpVerificationDataSource {
  Future<OtpVerificationResponseModal> doVerifyOtp(Map<String, dynamic> data);
}

class OtpVerificationDataSourceImplementation
    implements OtpVerificationDataSource {
  final Dio dio;

  OtpVerificationDataSourceImplementation({required this.dio});

  @override
  Future<OtpVerificationResponseModal> doVerifyOtp(
      Map<String, dynamic> data) async {
    String url = 'api/webservice/otp/verify';
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'content-type': 'application/json'}),
      );
      final model = OtpVerificationResponseModal.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
