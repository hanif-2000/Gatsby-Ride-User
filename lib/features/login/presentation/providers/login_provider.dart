import 'dart:developer';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../domain/usecases/do_login.dart';
import 'login_state.dart';

class LoginProvider extends FormProvider {
  final DoLogin doLogin;

  LoginProvider({required this.doLogin});

  Stream<LoginState> doLoginApi() async* {
    yield LoginLoading();

    final loginResult = await doLogin.call(
        emailController.text, passwordController.text, "app");

    yield* loginResult.fold((statusCode) async* {
      log(statusCode.toString());
      log("yield======" + statusCode.message);

      yield LoginFailure(failure: statusCode.message);
    }, (result) async* {
      log("Result success ==" + result!.success.toString());
      log("Result message ==" + result.message.toString());

      // log(result.data!.name.toString());
      // log(result.data!.toString());

      // log("result==>" + result.toString());
      if (result.success != 0) {
        yield LoginSuccess(data: result);
      } else {
        yield LoginFailure(failure: result.message!);
      }
    });
  }
}
