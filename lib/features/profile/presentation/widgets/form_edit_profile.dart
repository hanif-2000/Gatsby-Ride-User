import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/pages/change_email_page.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/profile_edit_provider.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/widgets/profile_image_result.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';

import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

import '../../../../core/utility/validation_helper.dart';
import '../providers/profile_state.dart';

class FormEditProfile extends StatefulWidget {
  const FormEditProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<FormEditProfile> createState() => _FormEditProfileState();
}

class _FormEditProfileState extends State<FormEditProfile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditProvider>(builder: (context, provider, _) {
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ProfileImagePicker(
                          imageURL: mergePhotoUrl(provider.imageUrl),
                          provider: provider,
                        ),
                      ),
                    ),
                    CustomTextField(
                      placeholder: appLoc.name,
                      title: appLoc.name,
                      controller: provider.nameController,
                      inputType: TextInputType.name,
                      isError: provider.nameError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setNameError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),
                    CustomTextField(
                      placeholder: appLoc.phoneNumber,
                      title: appLoc.phoneNumber,
                      controller: provider.phoneController,
                      inputType: TextInputType.phone,
                      isError: provider.phoneError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setPhoneError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ChangeEmailPage.routeName,
                        );
                      },
                      child: CustomTextField(
                        enabled: false,
                        title: appLoc.emailAddress,
                        controller: provider.emailController,
                        inputType: TextInputType.emailAddress,
                        isError: provider.emailError,
                        fieldValidator: ValidationHelper(
                          loc: appLoc,
                          isError: (bool value) =>
                              provider.setEmailError = value,
                          typeField: TypeField.email,
                        ).validate(),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomButton(
                        text: Text(
                          appLoc.save,
                          style: txtButtonStyle,
                        ),
                        buttonHeight:
                            MediaQuery.of(context).size.height * 0.080,
                        isRounded: true,
                        event: () {
                          if (provider.formKey.currentState!.validate()) {
                            provider
                                .updateProfileForm(
                                    name: provider.nameController.text,
                                    phone: provider.phoneController.text,
                                    photo: provider.imageFile)
                                .listen((event) {
                              switch (event.runtimeType) {
                                case ProfileLoading:
                                  showLoading();
                                  break;
                                case ProfileFailure:
                                  final msg = (event as ProfileFailure).failure;
                                  showToast(message: msg);
                                  dismissLoading();
                                  break;
                                case ProfileUpdateSuccess:
                                  dismissLoading();
                                  showToast(message: appLoc.profileUpdated);
                                  Navigator.pop(context, true);

                                  break;
                                default:
                                  showLoading();
                                  break;
                              }
                            });
                          }
                        },
                        bgColor: primaryDarkColor),
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
