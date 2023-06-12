import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/profile/domain/usecases/update_email.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/profile_state.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/presentation/providers/form_provider.dart';

class ChangeEmailProvider extends FormProvider {
  final UpdateEmail updateEmail;

  ChangeEmailProvider({required this.updateEmail});

  Stream<ProfileState> updateEmaileForm({required String email}) async* {
    yield ProfileLoading();
    final data = FormData.fromMap({
      'email': email,
    });
    final result = await updateEmail.execute(data);
    yield* result.fold((failure) async* {
      logMe("Failureeeee");
      yield ProfileFailure(failure: failure.message);
    }, (data) async* {
      refreshEmail();
      yield ProfileUpdateSuccess(success: data);
    });
  }
}
