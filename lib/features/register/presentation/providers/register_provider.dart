import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../domain/usecases/do_register.dart';
import 'register_state.dart';

class RegisterProvider extends FormProvider {
  final DoRegister doRegister;

  RegisterProvider({required this.doRegister});

  Stream<RegisterState> doRegisterApi(
      {required String name,
      required String email,
      // required String phone,
      required String password}) async* {
    yield RegisterLoading();
    final deviceToken = await FirebaseMessaging.instance.getToken()??"";
    final data = {
      'name': email.split('@').first,
      'email': email,
      'password': password,
      'device_type': sessionHelper.device,
      'fcm_token': deviceToken,
    };
    final result = await doRegister.call(data);
    logMe('result123---');
    logMe('result$result');
    yield* result.fold((statusCode) async* {
      yield RegisterFailure(failure: statusCode.message);
    }, (result) async* {
      logMe('result---');
      yield RegisterSuccess(data: result);
    });
  }
}
