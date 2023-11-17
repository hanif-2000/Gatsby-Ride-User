import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/login/presentation/pages/login_page.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/change_password_provider.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';

import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/validation_helper.dart';
import '../providers/profile_state.dart';

class FormChangePassword extends StatefulWidget {
  final String? email;
  const FormChangePassword({Key? key, this.email}) : super(key: key);

  @override
  State<FormChangePassword> createState() => _FormChangePasswordState();
}

class _FormChangePasswordState extends State<FormChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangePasswordProvider>(builder: (context, provider, _) {
      return Form(
        key: provider.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child:
                              Icon(Icons.arrow_back, color: black15141FColor),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        appLoc.resetYourPassword,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "poPPinSemiBold",
                          fontWeight: FontWeight.w600,
                          color: black15141FColor,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Text(
                      appLoc.atLeast8CharactersAndLetters,
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
                    const SizedBox(
                      height: 60,
                    ),
                    CustomTextField(
                      placeholder: appLoc.newPwd,

                      title: appLoc.newPwd,
                      controller: provider.passwordController,
                      inputType: TextInputType.visiblePassword,
                      isSecure: true,
                      isError: provider.passwordError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) =>
                            provider.setPasswordError = value,
                        typeField: TypeField.password,
                      ).validate(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      // prefixIcon: Image.asset(
                      //   passwordLockIcon,
                      //   width: 24,
                      //   height: 24,
                      // ),
                    ),
                    mediumVerticalSpacing(),

                    CustomTextField(
                      placeholder: appLoc.confirmPassword,
                      // placeholder: appLoc.confirmPassword,
                      // title: appLoc.confirmPassword,
                      controller: provider.confirmPasswordController,
                      inputType: TextInputType.visiblePassword,
                      isSecure: true,
                      isError: provider.confirmPasswordError,
                      // fieldValidator: ValidationHelper(
                      //   loc: appLoc,
                      //   isError: (bool value) =>
                      //       provider.setConfirmPasswordError = value,
                      //   typeField: TypeField.confirmPassword,
                      // ).validate(context),
                      fieldValidator: (val) {
                        if (val == '') {
                          return appLoc.mustNotEmpty;
                        }
                        if (val != provider.passwordController.text) {
                          return appLoc.confirmationPwdNotMatch;
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.lock_outline),
                      // prefixIcon: Image.asset(
                      //   passwordLockIcon,
                      //   width: 24,
                      //   height: 24,
                      // ),
                    ),

                    // CustomTextField(
                    //   placeholder: "Confirm Password",
                    //   // placeholder: appLoc.confirmPassword,
                    //   // title: appLoc.confirmPassword,
                    //   controller: provider.confirmPasswordController,
                    //   inputType: TextInputType.visiblePassword,
                    //   isSecure: true,
                    //   isError: provider.confirmPasswordError,
                    //   fieldValidator: ValidationHelper(
                    //     loc: appLoc,
                    //     isError: (bool value) =>
                    //         provider.setConfirmPasswordError = value,
                    //     typeField: TypeField.confirmPassword,
                    //   ).validate(),
                    //   prefixIcon: const Icon(Icons.lock_outline),
                    //   // prefixIcon: Image.asset(
                    //   //   passwordLockIcon,
                    //   //   width: 24,
                    //   //   height: 24,
                    //   // ),
                    // ),

                    const SizedBox(
                      height: 40,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                    //   child: Center(
                    //     child: Text(
                    //       appLoc.enterYourNewPwd,
                    //       style: formLabelHeaderStyle,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // CustomTextField(
                    //   placeholder: appLoc.currentPwd,
                    //   title: appLoc.currentPwd,
                    //   controller: provider.currentPasswordController,
                    //   inputType: TextInputType.visiblePassword,
                    //   isSecure: true,
                    //   isError: provider.passwordError,
                    //   fieldValidator: (val) {
                    //     if (val == '') {
                    //       return appLoc.mustNotEmpty;
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // mediumVerticalSpacing(),
                    // CustomTextField(
                    //   placeholder: appLoc.newPwd,
                    //   title: appLoc.newPwd,
                    //   controller: provider.passwordController,
                    //   inputType: TextInputType.visiblePassword,
                    //   isSecure: true,
                    //   isError: provider.passwordError,
                    //   fieldValidator: (val) {
                    //     if (val == '') {
                    //       return appLoc.mustNotEmpty;
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // mediumVerticalSpacing(),
                    // CustomTextField(
                    //   placeholder: appLoc.reTypeNewPassword,
                    //   title: appLoc.reTypeNewPassword,
                    //   controller: provider.passwordConfirmController,
                    //   inputType: TextInputType.visiblePassword,
                    //   isSecure: true,
                    //   isError: provider.passwordError,
                    //   fieldValidator: (val) {
                    //     if (val == '') {
                    //       return appLoc.mustNotEmpty;
                    //     }
                    //     if (val != provider.passwordController.text) {
                    //       return appLoc.confirmationPwdNotMatch;
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 50,
                    // ),
                    CustomButton(
                        // buttonHeight:
                        //     MediaQuery.of(context).size.height * 0.080,
                        buttonHeight: 50,
                        isRounded: true,
                        text: Text(
                          appLoc.save,
                          style: const TextStyle(
                              fontFamily: 'poPPinSemiBold',
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        event: () {
                          logMe(widget.email);
                          logMe(provider.passwordController.text);

                          if (provider.formKey.currentState!.validate()) {
                            provider
                                .updatePasswordForm(
                              email: widget.email!,
                              // currentPwd:
                              //     provider.currentPasswordController.text,
                              newPwd: provider.passwordController.text,
                              // confirmPwd:
                              //     provider.passwordConfirmController.text
                            )
                                .listen((event) {
                              switch (event.runtimeType) {
                                case ProfileLoading:
                                  showLoading();
                                  break;
                                case ProfileFailure:
                                  showToast(
                                      message: appLoc.failedToChangeEmail);
                                  dismissLoading();
                                  break;
                                case ChangePasswordSuccess:
                                  final data =
                                      (event as ChangePasswordSuccess).data;
                                  dismissLoading();
                                  if (data.success == 1) {
                                    showToast(message: appLoc.success);
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      LoginPage.routeName,
                                      (route) => false,
                                    );
                                  } else {
                                    if (data.message == '4') {
                                      showToast(
                                          message: appLoc.currentPwdIncorrect);
                                    } else {
                                      showToast(message: appLoc.failed);
                                    }
                                  }

                                  break;
                                default:
                                  showLoading();
                                  break;
                              }
                            });
                          }
                        },
                        bgColor: black080809Color)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
