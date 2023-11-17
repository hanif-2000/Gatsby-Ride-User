import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/injection.dart';
import '../providers/forgot_password_provider.dart';
import '../widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  static const routeName = '/ForgotPasswordPage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => locator<ForgotPasswordProvider>(),
        child: Scaffold(
          backgroundColor: whiteColor,
          // appBar: CustomAppTtitleBar(
          //   centerTitle: true,
          //   canBack: true,
          //   backgroundColor: primaryColor,
          //   title: appLoc.changePassword.toUpperCase(),
          //   hideShadow: true,
          // ),
          body: SafeArea(
            child: ListView(
              children: [
                AspectRatio(
                  // aspectRatio: 3 / 0.8,
                  aspectRatio: 5 / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: Icon(Icons.arrow_back,
                                  color: black15141FColor),
                            ),
                          ),
                        ),
                        const Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Reset your password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "poPPinSemiBold",
                                fontWeight: FontWeight.w600,
                                color: black15141FColor,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        const Flexible(
                          // fit: FlexFit.loose,
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Enter your official email to get a verification code.",
                              // appLoc.welcome.toUpperCase(),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontFamily: "poPPinMedium",
                                fontWeight: FontWeight.w500,
                                color: grey7C7C7CColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        // Flexible(
                        //   fit: FlexFit.loose,
                        //   flex: 1,
                        //   child: Text(
                        //     appLoc.pleaseEnterYourEmailAddress,
                        //     textAlign: TextAlign.center,
                        //     style: const TextStyle(
                        //             fontSize: 15,
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.bold)
                        //         .useHiraginoKakuW6Font(),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const FormForgotPassword(),
                mediumVerticalSpacing(),
              ],
            ),
          ),
        ));
  }
}
