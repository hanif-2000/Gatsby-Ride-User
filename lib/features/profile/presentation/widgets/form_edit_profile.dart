import 'dart:developer';
import 'dart:io';

import 'package:GetsbyRideshare/core/static/assets.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/profile_edit_provider.dart';
import 'package:country_picker/country_picker.dart';
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
import '../providers/profile_provider.dart';
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
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 140,
                                  height: 140,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: provider.imageFilePath == ''
                                        ? DynamicCachedNetworkImage(
                                            imageUrl: mergePhotoUrl(
                                                provider.imageUrl),
                                          )
                                        : Image.file(
                                            File(provider.imageFile!.path),
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  child: Visibility(
                                    visible: Provider.of<ProfileProvider>(
                                            context,
                                            listen: true)
                                        .isProfileEdit,
                                    child: InkWell(
                                      onTap: () {
                                        log("imgURL IS:  " +
                                            provider.imageFilePath.toString());
                                        provider.showImagePicker(
                                            context: context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color: whiteColor,
                                        ),
                                        height: 50,
                                        width: 50.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: SvgPicture.asset(
                                            'assets/icons/edit_camera.svg',
                                            height: 20.0,
                                            width: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: Visibility(
                              visible: !Provider.of<ProfileProvider>(context,
                                      listen: false)
                                  .isProfileEdit,
                              child: InkWell(
                                onTap: () {
                                  Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .toggleIsProfileEdit();
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Center(
                                          child: SvgPicture.asset(
                                              'assets/icons/edit.svg')),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                      appLoc.firstName,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "poPPinRegular",
                          color: greyA2A0A8Color),
                    ),
                    CustomTextField(
                      readOnly: !Provider.of<ProfileProvider>(
                        context,
                        listen: true,
                      ).isProfileEdit,
                      placeholder: appLoc.name,
                      title: appLoc.name,
                      controller: provider.firstNameController,
                      inputType: TextInputType.name,
                      // isError: provider.nameError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setNameError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),

                    Text(
                      appLoc.lastName,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "poPPinRegular",
                          color: greyA2A0A8Color),
                    ),
                    CustomTextField(
                      readOnly:
                          !Provider.of<ProfileProvider>(context, listen: true)
                              .isProfileEdit,
                      placeholder: appLoc.phoneNumber,
                      title: appLoc.phoneNumber,
                      controller: provider.lastNameController,
                      inputType: TextInputType.name,
                      // isError: provider.phoneError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setPhoneError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),

                    Text(
                      appLoc.mobileNo,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "poPPinRegular",
                          color: greyA2A0A8Color),
                    ),
                    CustomTextField(
                      readOnly:
                          !Provider.of<ProfileProvider>(context, listen: true)
                              .isProfileEdit,
                      placeholder: appLoc.phoneNumber,
                      title: appLoc.phoneNumber,
                      controller: provider.phoneController,
                      inputType: TextInputType.phone,
                      // isError: provider.phoneError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setPhoneError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),
                    Text(
                      appLoc.country,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "poPPinRegular",
                          color: greyA2A0A8Color),
                    ),
                    // CustomTextField(
                    //   readOnly:
                    //       !Provider.of<ProfileProvider>(context, listen: true)
                    //           .isProfileEdit,
                    //   placeholder: "Country",
                    //   title: appLoc.phoneNumber,
                    //   controller: provider.countryController,
                    //   inputType: TextInputType.name,
                    //   // isError: provider.phoneError,
                    //   fieldValidator: ValidationHelper(
                    //     loc: appLoc,
                    //     isError: (bool value) => provider.setPhoneError = value,
                    //     typeField: TypeField.name,
                    //   ).validate(),
                    // ),
                    // mediumVerticalSpacing(),

                    CustomTextField(
                      // onTap: () {
                      //   showCountryPicker(
                      //     context: context,
                      //     //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                      //     exclude: <String>['KN', 'MF'],
                      //     favorite: <String>['SE'],
                      //     //Optional. Shows phone code before the country name.
                      //     showPhoneCode: true,
                      //     onSelect: (Country country) {
                      //       print('Select country: ${country.displayName}');
                      //     },
                      //     // Optional. Sets the theme for the country list picker.
                      //     countryListTheme: CountryListThemeData(
                      //       // Optional. Sets the border radius for the bottomsheet.
                      //       borderRadius: const BorderRadius.only(
                      //         topLeft: Radius.circular(40.0),
                      //         topRight: Radius.circular(40.0),
                      //       ),
                      //       // Optional. Styles the search field.
                      //       inputDecoration: InputDecoration(
                      //         labelText: 'Search',
                      //         hintText: 'Start typing to search',
                      //         prefixIcon: const Icon(Icons.search),
                      //         border: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             color: const Color(0xFF8C98A8).withOpacity(0.2),
                      //           ),
                      //         ),
                      //       ),
                      //       // Optional. Styles the text in the search field
                      //       searchTextStyle: const TextStyle(
                      //         color: Colors.blue,
                      //         fontSize: 18,
                      //       ),
                      //     ),
                      //   );
                      // },
                      readOnly: true,
                      placeholder: provider.selectedCountry.text == ''
                          ? provider.countryController.text
                          : provider.selectedCountry.text,
                      controller: provider.selectedCountry == ''
                          ? provider.countryController
                          : provider.selectedCountry,
                      suffixWidget: InkWell(
                          onTap: Provider.of<ProfileProvider>(context,
                                      listen: true)
                                  .isProfileEdit
                              ? () {
                                  showCountryPicker(
                                    context: context,
                                    exclude: ['KN', 'MF'],
                                    onSelect: (Country country) {
                                      provider.updateCountry(
                                        value: country.displayNameNoCountryCode,
                                      );
                                      logMe(
                                          'Select country: ${country.displayNameNoCountryCode}');
                                    },
                                    countryListTheme: CountryListThemeData(
                                      // Optional. Sets the border radius for the bottomsheet.
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(40.0),
                                        topRight: Radius.circular(40.0),
                                      ),
                                      // Optional. Styles the search field.
                                      inputDecoration: InputDecoration(
                                        labelText: 'Search',
                                        hintText: 'Start typing to search',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color(0xFF8C98A8)
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      // Optional. Styles the text in the search field
                                      searchTextStyle: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                }
                              : () {},
                          child: Image.asset(dropdownIcon)),
                      fieldValidator: (val) {
                        // if (val == '') {
                        //   return appLoc.mustNotEmpty;
                        // }
                        return null;
                      },
                    ),

                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pushNamed(
                    //       context,
                    //       ChangeEmailPage.routeName,
                    //     );
                    //   },
                    //   child: CustomTextField(
                    //     enabled: false,
                    //     title: appLoc.emailAddress,
                    //     controller: provider.emailController,
                    //     inputType: TextInputType.emailAddress,
                    //     isError: provider.emailError,
                    //     fieldValidator: ValidationHelper(
                    //       loc: appLoc,
                    //       isError: (bool value) =>
                    //           provider.setEmailError = value,
                    //       typeField: TypeField.email,
                    //     ).validate(),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 50,
                    // ),

                    //Save Button
                    Visibility(
                      visible:
                          Provider.of<ProfileProvider>(context, listen: true)
                              .isProfileEdit,
                      child: CustomButton(
                        text: Text(
                          appLoc.saveDetails,
                          style: txtButtonStyle,
                        ),
                        buttonHeight:
                            MediaQuery.of(context).size.height * 0.080,
                        isRounded: true,
                        event: () {
                          log(provider.firstNameController.text);
                          log(provider.lastNameController.text);
                          log(provider.phoneController.text);
                          log(provider.selectedCountry.text);

                          log(provider.imageUrl);
                          // log(provider.imageFile!.path.toString());

                          if (provider.formKey.currentState!.validate()) {
                            provider
                                .updateProfileForm(
                                    firstName:
                                        provider.firstNameController.text,
                                    lastName: provider.lastNameController.text,
                                    country: provider.selectedCountry.text,
                                    phone: provider.phoneController.text,
                                    photo: provider.imageFile ?? null)
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
                        bgColor: blackColor,
                      ),
                    ),
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
