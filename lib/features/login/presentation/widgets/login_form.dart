import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/widgets/custom_text_field.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/static/dimens.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/forgot_password/presentation/pages/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../../../../core/utility/validation_helper.dart';
import '../../../../socket/latest_socket_provider.dart';
import '../providers/login_provider.dart';
import '../providers/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var socketProvider = locator<LatestSocketProvider>();
  void submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    final provider = context.read<LoginProvider>();
    provider.doLoginApi().listen((state) async {
      log(state.toString());
      switch (state.runtimeType) {
        case LoginLoading:
          showLoading();

          break;
        case LoginFailure:
          final msg = (state as LoginFailure).failure;

          // log("-------->>>>>>" + msg.toString());
          dismissLoading();

          showToast(message: msg);
          break;
        case LoginSuccess:
          dismissLoading();

          final session = locator<Session>();
          session.setLoggedIn = true;
          showToast(message: "Login Success");

          socketProvider.connectToSocket(context);
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.routeName, (route) => false);
          logMe("Authorization Token: ${session.sessionToken}");
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, _) => Form(
        key: provider.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: sizeMedium,
          ),
          child: Column(
            children: [
              CustomTextField(
                title: appLoc.emailAddress,
                placeholder: appLoc.emailAddress,
                controller: provider.emailController,
                inputType: TextInputType.emailAddress,
                isError: provider.emailError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setEmailError = value,
                  typeField: TypeField.email,
                ).validate(),
                focusNode: FocusNode(),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  //     size: 15,
                  // color:FocusNode().hasFocus? yellowE5A829Color: greyEBEBEBColor
                ),
              ),
              mediumVerticalSpacing(),
              CustomTextField(
                title: appLoc.password,
                placeholder: appLoc.password,
                controller: provider.passwordController,
                inputType: TextInputType.visiblePassword,
                isSecure: true,
                isError: provider.passwordError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setPasswordError = value,
                  typeField: TypeField.password,
                ).validate(),
                prefixIcon: const Icon(Icons.lock_outline),
                // prefixIcon: Image.asset(passwordLockIcon,width: 24,height: 24,),
              ),
              mediumVerticalSpacing(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ForgotPasswordPage.routeName,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Forgot Password?",
                        // appLoc.forgotPassword,
                        style: TextStyle(
                          fontSize: 14,
                          color: grey7C7C7CColor,
                          fontFamily: 'poPPinRegular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              smallVerticalSpacing(),
              CustomButton(
                text: const Text(
                  "Log In",
                  // appLoc.login.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'poPPinSemiBold',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                event: () async {
                  if (provider.formKey.currentState!.validate()) {
                    submit();
                  }
                },
                buttonHeight: 50,
                // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                isRounded: true,
                bgColor: black080809Color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
