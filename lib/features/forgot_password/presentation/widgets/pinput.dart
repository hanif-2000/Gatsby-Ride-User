import 'dart:developer';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/providers/forgot_password_provider.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/providers/forgot_password_state.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/providers/otp_verification_provider.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/providers/otp_verification_state.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/pages/change_password_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PinPutForm extends StatefulWidget {
  final String email;

  const PinPutForm({Key? key, required this.email}) : super(key: key);

  @override
  State<PinPutForm> createState() => _PinPutFormState();
}

class _PinPutFormState extends State<PinPutForm> {
  void onVerify(String email, String otp) {
    logMe('on verify email-----------$email');
    logMe('on verify email---------------$otp');

    final provider = context.read<OtpVerificationProvider>();
    provider.doOtpVerifyApi(email: email, otp: otp).listen((state) async {
      switch (state.runtimeType) {
        case OtpVerificationLoading:
          showLoading();
          break;
        case OtpVerificationFailure:
          final msg = (state as OtpVerificationFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case OtpVerificationSuccess:
          final data = (state as OtpVerificationSuccess).data;
          dismissLoading();
          if (data.success == 1) {
            showToast(message: "Otp Verified");

            log("Otp Verified Successfully");
            // Navigator.pushNamed(
            //   context,
            //   ChangePasswordPage.routeName,
            // );

            Navigator.pushNamed(context, ChangePasswordPage.routeName,
                arguments: {"email": email});
          } else {
            if (data.message == '1') {
              showToast(message: "Invalid Otp");
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
      return Column(
        children: [
          Pinput(
            onChanged: (value) {
              if (kDebugMode) {
                logMe(value.toString());
              }
            },
            onCompleted: (v) {
              provider.updateOtp(value: v);
              logMe(v.toString());
            },
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            length: 4,
            toolbarEnabled: false,
            defaultPinTheme: PinTheme(
              width: 64,
              height: 75,
              decoration: BoxDecoration(
                  color: greyF7F7F7Color,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: greyB6B6B6Color, width: 2)),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 40,
                  color: greyB6B6B6Color,
                  fontFamily: "poPPinRegular"),
            ),
            focusedPinTheme: PinTheme(
              width: 64,
              height: 75,
              decoration: BoxDecoration(
                color: greyF7F7F7Color,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: yellowE5A829Color, width: 2),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Don’t receive OTP code ? ",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "poPPinRegular",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: grey767676Color),
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              final provider = context.read<ForgotPasswordProvider>();
              provider
                  .doForgotPasswordApi(email: widget.email)
                  .listen((state) async {
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
                      showToast(message: "Resend Code Sucess");
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
            },
            child: const Text(
              "Resend Code",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "poPPinSemiBold",
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: yellowE5A829Color),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomButton(
              // buttonHeight: MediaQuery.of(context).size.height * 0.080,
              buttonHeight: 50,
              isRounded: true,
              text: const Text(
                "Verify Now",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'poPPinSemiBold',
                  fontWeight: FontWeight.w600,
                ),
              ),
              event: () {
                logMe(widget.email.toString());

                logMe(provider.otp.toString());
                onVerify(widget.email, provider.otp);
                // final provider = context.read<OtpVerificationProvider>();

                // provider.getEmailFromLocal();

                // var email = context
                //     .watch<ForgotPasswordProvider>(context,listem)
                //     .emailController
                //     .text;

                // logMe(email.toString());
                // fetchCurrency().listen((state) )
                // of<ForgotPasswordProvider>(context)
                //     .emailController
                //     .text;

                // log(someResult.toString());
                // Navigator.pushNamed(
                //   context,
                //   ChangePasswordPage.routeName,
                // );
                // if (provider.formKey.currentState!.validate()) {
                // submit(provider.emailController.text);
                // }
              },
              bgColor: black080809Color,
              // bgColor: primaryDarkColor
            ),
          )
        ],
      );
    });
  }
}
