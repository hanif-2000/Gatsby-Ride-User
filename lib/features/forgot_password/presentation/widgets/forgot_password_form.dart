import 'dart:developer';

import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/pages/otp_verification_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';

import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

import '../../../../core/utility/validation_helper.dart';
import '../providers/forgot_password_provider.dart';
import '../providers/forgot_password_state.dart';

class FormForgotPassword extends StatefulWidget {
  const FormForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<FormForgotPassword> createState() => _FormForgotPasswordState();
}

class _FormForgotPasswordState extends State<FormForgotPassword> {
  void submit(String email) {
    final provider = context.read<ForgotPasswordProvider>();
    provider.doForgotPasswordApi(email: email).listen((state) async {
      switch (state.runtimeType) {
        case ForgotPasswordLoading:
          showLoading();
          break;
        case ForgotPasswordFailure:
          final msg = (state as ForgotPasswordFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case ForgotPasswordSuccess:
          final data = (state as ForgotPasswordSuccess).data;
          dismissLoading();
          if (data.success == 1) {
            showToast(message: appLoc.pwdReset);

            log("Otp Send Successfully ----- $email");
            Navigator.pushNamed(context, OtpVerificationPage.routeName,
                arguments: {"email": email});
          } else {
            if (data.message == '1') {
              showToast(message: appLoc.emailHasBeenTaken);
            } else {
              showToast(message: appLoc.registrationFailed);
            }
          }

          break;
      }
    });
  }

  // updatePassword({required String email, required String newPsd}) {

  //      final provider = context.read<ForgotPasswordProvider>();
  //   provider.doForgotPasswordApi(email: email).listen((state) async {
  //     switch (state.runtimeType) {
  //       case ForgotPasswordLoading:
  //         showLoading();
  //         break;
  //       case ForgotPasswordFailure:
  //         final msg = (state as ForgotPasswordFailure).failure;
  //         dismissLoading();
  //         showToast(message: msg);
  //         break;
  //       case ForgotPasswordSuccess:
  //         final data = (state as ForgotPasswordSuccess).data;
  //         dismissLoading();
  //         if (data.success == 1) {
  //           showToast(message: appLoc.pwdReset);

  //           log("Otp Send Successfully");
  //           Navigator.pushNamed(
  //             context,
  //             OtpVerificationPage.routeName,
  //           );
  //         } else {
  //           if (data.message == '1') {
  //             showToast(message: appLoc.emailHasBeenTaken);
  //           } else {
  //             showToast(message: appLoc.registrationFailed);
  //           }
  //         }

  //         break;
  //     }
  //   });

  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgotPasswordProvider>(builder: (context, provider, _) {
      return Form(
        key: provider.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: sizeMedium,
          ),
          child: Column(
            children: [
              CustomTextField(
                placeholder: appLoc.emailAddress,
                title: appLoc.emailAddress,
                controller: provider.emailController,
                inputType: TextInputType.emailAddress,
                isError: provider.emailError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setEmailError = value,
                  typeField: TypeField.email,
                ).validate(),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              largeVerticalSpacing(),
              CustomButton(
                buttonHeight: 50,
                // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                isRounded: true,
                text: Text(
                  appLoc.send,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'poPPinSemiBold',
                      fontWeight: FontWeight.w600),
                ),
                event: () {
                  // Navigator.pushNamed(
                  //   context,
                  //   OtpVerificationPage.routeName,
                  // );
                  if (provider.formKey.currentState!.validate()) {
                    submit(provider.emailController.text);
                  }
                },
                bgColor: black080809Color,
                // bgColor: primaryDarkColor
              )
            ],
          ),
        ),
      );
    });
  }
}
