import 'package:dio/dio.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../domain/usecases/do_forgot_password.dart';
import 'forgot_password_state.dart';

class ForgotPasswordProvider extends FormProvider {
  final DoForgotPassword doForgotPassword;
  // final DoOtpVerify doOtpVerify;

  String otp = '';

  ForgotPasswordProvider({required this.doForgotPassword});

  Stream<ForgotPasswordState> doForgotPasswordApi(
      {required String email}) async* {
    // saveEmailToLocal();
    yield ForgotPasswordLoading();
    final formData = FormData.fromMap({
      'email': email,
      'type': "Customer",
    });
    final result = await doForgotPassword.call(formData);
    yield* result.fold((statusCode) async* {
      yield ForgotPasswordFailure(failure: statusCode.message);
    }, (result) async* {
      yield ForgotPasswordSuccess(data: result);
    });
  }

  updateOtp({value}) {
    otp = value;
    notifyListeners();
  }
}
