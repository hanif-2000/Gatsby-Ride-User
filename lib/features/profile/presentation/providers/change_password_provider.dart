import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/profile/domain/usecases/update_password.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/profile_state.dart';
import 'package:dio/dio.dart';

import '../../../../core/presentation/providers/form_provider.dart';

class ChangePasswordProvider extends FormProvider {
  final UpdatePassword updatePassword;

  ChangePasswordProvider({required this.updatePassword});

  Stream<ProfileState> updatePasswordForm({
    required String email,
    required String newPwd,
    // required String confirmPwd,
  }) async* {
    yield ProfileLoading();
    final data = FormData.fromMap({
      'email': email,
      'password': newPwd,
      // 'password_confirmation': confirmPwd,
    });
    final result = await updatePassword.execute(data);
    yield* result.fold((failure) async* {
      logMe("Failureeeee");
      yield ProfileFailure(failure: failure.message);
    }, (data) async* {
      if (data.success == 1) {
        refreshPassword();
      }
      yield ChangePasswordSuccess(data: data);
    });
  }
}
