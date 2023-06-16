import 'package:appkey_taxiapp_user/features/forgot_password/data/models/otp_verification_response_modal.dart';
import 'package:dio/dio.dart';

abstract class OtpVerificationDataSource {
  Future<OtpVerificationResponseModal> doVerifyOtp(FormData formData);
}

class OtpVerificationDataSourceImplementation
    implements OtpVerificationDataSource {
  final Dio dio;

  OtpVerificationDataSourceImplementation({required this.dio});

  @override
  Future<OtpVerificationResponseModal> doVerifyOtp(FormData formData) async {
    String url = 'api/webservice/otp/verify';

    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = OtpVerificationResponseModal.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
