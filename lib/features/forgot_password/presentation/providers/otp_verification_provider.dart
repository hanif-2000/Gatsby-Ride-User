import 'package:GetsbyRideshare/core/presentation/providers/form_provider.dart';
import 'package:GetsbyRideshare/features/forgot_password/presentation/providers/otp_verification_state.dart';
import 'package:dio/dio.dart';

import '../../domain/usecases/otp_verification.dart';

class OtpVerificationProvider extends FormProvider {
  final DoOtpVerify? doOtpVerify;

  OtpVerificationProvider({this.doOtpVerify});

  Stream<OtpVerificationState> doOtpVerifyApi({
    required String email,
    required String otp,
  }) async* {
    yield OtpVerificationLoading();
    final formData = FormData.fromMap({
      'email': email,
      'otp': otp,
      'type': "Customer",
    });
    final result = await doOtpVerify!.call(formData);
    yield* result.fold((statusCode) async* {
      yield OtpVerificationFailure(failure: statusCode.message);
    }, (result) async* {
      yield OtpVerificationSuccess(data: result);
    });
  }
}
