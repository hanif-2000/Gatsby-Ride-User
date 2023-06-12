import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/core/utility/injection.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/providers/forgot_password_provider.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/presentation/widgets/pinput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/static/colors.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({Key? key, this.email}) : super(key: key);
  final String? email;
  static const routeName = '/OtpVerificationPage';

  @override
  Widget build(BuildContext context) {
    logMe("email ----> $email");
    return ChangeNotifierProvider(
      create: (context) => locator<ForgotPasswordProvider>(),
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              AspectRatio(
                // aspectRatio: 3 / 0.8,
                aspectRatio: 5 / 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(0.0),
                            child:
                                Icon(Icons.arrow_back, color: black15141FColor),
                          ),
                        ),
                      ),
                      const Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Text(
                          "OTP Verification",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "poPPinSemiBold",
                            fontWeight: FontWeight.w600,
                            color: black15141FColor,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Flexible(
                        // fit: FlexFit.loose,
                        flex: 1,
                        child: Text(
                          "Enter OTP Code sent to $email",
                          // appLoc.welcome.toUpperCase(),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(
                            fontFamily: "poPPinMedium",
                            fontWeight: FontWeight.w500,
                            color: grey7C7C7CColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              PinPutForm(email: email!),
              // Pinput(
              //   onChanged: (value) {
              //     if (kDebugMode) {
              //       log(value.toString());
              //     }
              //   },
              //   onCompleted: (v) {
              //     print(v.toString());
              //   },
              //   keyboardType: const TextInputType.numberWithOptions(
              //       signed: true, decimal: true),
              //   length: 4,
              //   toolbarEnabled: false,
              //   defaultPinTheme: PinTheme(
              //     width: 64,
              //     height: 75,
              //     decoration: BoxDecoration(
              //         color: greyF7F7F7Color,
              //         borderRadius: BorderRadius.circular(15),
              //         border: Border.all(color: greyB6B6B6Color, width: 2)),
              //     textStyle: const TextStyle(
              //         fontWeight: FontWeight.w400,
              //         fontSize: 40,
              //         color: greyB6B6B6Color,
              //         fontFamily: "poPPinRegular"),
              //   ),
              //   focusedPinTheme: PinTheme(
              //     width: 64,
              //     height: 75,
              //     decoration: BoxDecoration(
              //       color: greyF7F7F7Color,
              //       borderRadius: BorderRadius.circular(15),
              //       border: Border.all(color: yellowE5A829Color, width: 2),
              //     ),
              //   ),
              // ),

              // const SizedBox(
              //   height: 50,
              // ),
              // const Text(
              //   "Don’t receive OTP code ? ",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontFamily: "poPPinRegular",
              //       fontWeight: FontWeight.w400,
              //       fontSize: 14,
              //       color: grey767676Color),
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // const Text(
              //   "Resend Code",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontFamily: "poPPinSemiBold",
              //       fontWeight: FontWeight.w600,
              //       fontSize: 14,
              //       color: yellowE5A829Color),
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: CustomButton(
              //     // buttonHeight: MediaQuery.of(context).size.height * 0.080,
              //     buttonHeight: 50,
              //     isRounded: true,
              //     text: const Text(
              //       "Verify Now",
              //       style: TextStyle(
              //         fontSize: 14,
              //         color: Colors.white,
              //         fontFamily: 'poPPinSemiBold',
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     event: () {
              //       // final provider = context.read<OtpVerificationProvider>();

              //       // provider.getEmailFromLocal();

              //       // var email = context
              //       //     .watch<ForgotPasswordProvider>(context,listem)
              //       //     .emailController
              //       //     .text;

              //       // logMe(email.toString());
              //       // fetchCurrency().listen((state) )
              //       // of<ForgotPasswordProvider>(context)
              //       //     .emailController
              //       //     .text;

              //       // log(someResult.toString());
              //       Navigator.pushNamed(
              //         context,
              //         ChangePasswordPage.routeName,
              //       );
              //       // if (provider.formKey.currentState!.validate()) {
              //       // submit(provider.emailController.text);
              //       // }
              //     },
              //     bgColor: black080809Color,
              //     // bgColor: primaryDarkColor
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
