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

  // Future<void> signInWithGoogle() async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await googleSignIn.signIn();
  //   // if (googleSignInAccount != null) {
  //   //   final GoogleSignInAuthentication googleSignInAuthentication =
  //   //       await googleSignInAccount.authentication;
  //   //   final AuthCredential authCredential = GoogleAuthProvider.credential(
  //   //       idToken: googleSignInAuthentication.idToken,
  //   //       accessToken: googleSignInAuthentication.accessToken);

  //   //   // Getting users credential
  //   //   UserCredential result = await auth.signInWithCredential(authCredential);
  //   //   User user = result.user;

  //   //   if (result != null) {
  //   //     Navigator.pushReplacement(
  //   //         context, MaterialPageRoute(builder: (context) => HomePage()));
  //   //   } // if result not null we simply call the MaterialpageRoute,
  //   //   // for go to the HomePage screen
  //   // }
  // }
}
