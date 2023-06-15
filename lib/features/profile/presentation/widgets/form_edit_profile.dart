import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/pages/change_email_page.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/profile_edit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';

import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/presentation/widgets/dynamic_network_image.dart';
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 5 / 3,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: 140,
                              height: 140,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: DynamicCachedNetworkImage(
                                  imageUrl: mergePhotoUrl(provider.imageUrl),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: Container(
                              child: Row(
                                children: [
                                  Center(
                                      child: SvgPicture.asset(
                                          'assets/icons/edit.svg')),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: const Text(
                                      "Edit",
                                      style: TextStyle(
                                        fontFamily: "poPPinMedium",
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Center(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 20),
                    //     child: ProfileImagePicker(
                    //       imageURL: mergePhotoUrl(provider.imageUrl),
                    //       provider: provider,
                    //     ),
                    //   ),
                    // ),

                    Text(
                      "First Name",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "poPPinRegular",
                          color: greyA2A0A8Color),
                    ),
                    CustomTextField(
                      placeholder: appLoc.name,
                      title: appLoc.name,
                      controller: provider.firstNameController,
                      inputType: TextInputType.name,
                      isError: provider.nameError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setNameError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),

                    Text(
                      "Last Name",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "poPPinRegular",
                          color: greyA2A0A8Color),
                    ),
                    CustomTextField(
                      placeholder: appLoc.phoneNumber,
                      title: appLoc.phoneNumber,
                      controller: provider.lastNameController,
                      inputType: TextInputType.phone,
                      isError: provider.phoneError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setPhoneError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),

                    Text(
                      "Mobile Number",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "poPPinRegular",
                          color: greyA2A0A8Color),
                    ),
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
                    Text(
                      "Country",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "poPPinRegular",
                          color: greyA2A0A8Color),
                    ),
                    CustomTextField(
                      placeholder: appLoc.phoneNumber,
                      title: appLoc.phoneNumber,
                      controller: provider.countryController,
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
