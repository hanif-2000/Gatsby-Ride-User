import 'package:GetsbyRideshare/features/contact_us/domain/usecases/get_contactus.dart';
import 'package:GetsbyRideshare/features/contact_us/presentation/providers/contactus_state.dart';
import 'package:dio/dio.dart';

import '../../../../core/presentation/providers/form_provider.dart';

class ContactusProvider extends FormProvider {
  final DoContactUs doContactus;
  // final DoOtpVerify doOtpVerify;

  String otp = '';

  ContactusProvider({required this.doContactus});

  Stream<ContactusState> doContactusApi({
    required String email,
    required String message,
  }) async* {
    // saveEmailToLocal();
    yield ContactusLoading();
    final formData =
        FormData.fromMap({'email': email, 'type': 1, 'message': message});
    final result = await doContactus.call(formData);
    yield* result.fold((statusCode) async* {
      yield ContactusFailure(failure: statusCode.message);
    }, (result) async* {
      yield ContactusSuccess(data: result);
    });
  }
}
