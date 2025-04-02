import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/register/presentation/providers/register_provider.dart';
import 'package:GetsbyRideshare/features/terms_and_conditions/terms_and_conditions.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';

import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

import '../../../../core/utility/validation_helper.dart';
import '../../../profile/presentation/pages/create_profile_page.dart';
import '../providers/register_state.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({
    Key? key,
  }) : super(key: key);

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  void submit(String name, String email, String phone, String passsword) {
    final provider = context.read<RegisterProvider>();
    provider
        .doRegisterApi(
            // email: email, phone: phone, password: passsword, name: name
            email: email,
            password: passsword,
            name: "")
        .listen((state) async {
      switch (state.runtimeType) {
        case RegisterLoading:
          showLoading();
          break;
        case RegisterFailure:
          final msg = (state as RegisterFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case RegisterSuccess:
          final data = (state as RegisterSuccess).data;
          dismissLoading();
          if (data.success == 1) {
            showToast(message: appLoc.successfullyRegistered);
            Navigator.pushReplacementNamed(
              context,
              CreateProfilePage.routeName,
            );
            // Navigator.pushReplacementNamed(
            //   context,
            //   ProfilePage.routeName,
            // );
            // Navigator.pushReplacementNamed(context, LoginPage.routeName);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(builder: (context, provider, _) {
      return Form(
        key: provider.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: sizeMedium,
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      // size: 15,
                    ),
                  ),
                  mediumVerticalSpacing(),
                  CustomTextField(
                    placeholder: appLoc.password,
                    title: appLoc.password,
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
                    placeholder: "Confirm Password",
                    controller: provider.confirmPasswordController,
                    inputType: TextInputType.visiblePassword,
                    isSecure: true,
                    isError: provider.confirmPasswordError,
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
                  ),
                  mediumVerticalSpacing(),
                  Row(
                    children: [
                      Checkbox(
                        // value: false,
                        value: provider.checkBox,
                        onChanged: (value) {
                          provider.updateCheckBox();
                          print("checkBox${provider.checkBox}");
                        },
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.disabled)) {
                            return Colors.white;
                          }
                          return grey9B9B9BColor;
                        }),
                      ),
                      const Text(
                        "I Agree on ",
                        // appLoc.welcome.toUpperCase(),
                        style: TextStyle(
                          fontFamily: "poPPinMedium",
                          fontWeight: FontWeight.w500,
                          color: grey9B9B9BColor,
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionsPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Terms and Conditions ",
                          // appLoc.welcome.toUpperCase(),
                          style: TextStyle(
                            fontFamily: "poPPinMedium",
                            fontWeight: FontWeight.w500,
                            color: blackColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              largeVerticalSpacing(),
              CustomButton(
                  text: const Text(
                    "Sign up",
                    style: TextStyle(
                        fontFamily: 'poPPinSemiBold',
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    // appLoc.signup.toUpperCase(),
                    // style: txtButtonStyle,
                  ),
                  buttonHeight: 50,
                  // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                  isRounded: true,
                  event: () {
                    // Navigator.pushReplacementNamed(
                    //   context,
                    //   CreateProfilePage.routeName,
                    // );
                    if (provider.formKey.currentState!.validate()) {
                      if (provider.checkBox) {
                        submit(
                            "",
                            // provider.nameController.text,
                            provider.emailController.text,
                            provider.phoneController.text,
                            provider.passwordController.text);
                      } else {
                        showToast(
                            message: "Please Accept Terms and Conditions");
                      }
                    }
                  },
                  bgColor: black080809Color),
            ],
          ),
        ),
      );
    });
  }
}
