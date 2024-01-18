import 'dart:developer';

import 'package:GetsbyRideshare/core/presentation/pages/home_page/home_page.dart';
import 'package:GetsbyRideshare/core/presentation/widgets/custom_text_field.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/create_profile_provider.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/create_profile_state.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/upload_profile_image_provider.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/upload_profile_image_state.dart';
import 'package:GetsbyRideshare/socket/latest_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/utility/helper.dart';
import '../../../../core/utility/session_helper.dart';

class CreateProfileForm extends StatefulWidget {
  const CreateProfileForm({Key? key}) : super(key: key);

  @override
  State<CreateProfileForm> createState() => _CreateProfileFormState();
}

class _CreateProfileFormState extends State<CreateProfileForm> {
  var socketProvider = locator<LatestSocketProvider>();
  //Upload profile Image
  uploadProfileImage() {
    final provider = context.read<UploadProfileImageProvider>();
    provider.doUploadProfileImageApi(context).listen((state) async {
      switch (state.runtimeType) {
        case UploadProfileImageLoading:
          showLoading();
          break;
        case UploadProfileImageFailure:
          final msg = (state as UploadProfileImageFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case UploadProfileImageSuccess:
          final data = (state as UploadProfileImageSuccess).data;
          dismissLoading();
          if (data.success == 1) {
            log(data.fileName.toString());

            saveDetails(data.fileName);
            showToast(message: appLoc.profileImageUploadSuccess);
            // saveDetails();
            // Navigator.pushNamedAndRemoveUntil(
            //     context, HomePage.routeName, (route) => false);
          } else {
            if (data.message == '1') {
              showToast(message: appLoc.registrationFailed);
            } else {
              showToast(message: appLoc.registrationFailed);
            }
          }

          break;
      }
    });
  }

// Upload Other details of user
  saveDetails(profileImg) {
    final provider = context.read<CreateProfileProvider>();
    provider.doCreateProfileApi(profileImg).listen((state) async {
      switch (state.runtimeType) {
        case CreateProfileLoading:
          showLoading();
          break;
        case CreateProfileFailure:
          final msg = (state as CreateProfileFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case CreateProfileSuccess:
          final data = (state as CreateProfileSuccess).data;
          dismissLoading();
          if (data.success == 1) {
            final session = locator<Session>();
            session.setLoggedIn = true;
            showToast(message: appLoc.createProfileSuccessfully);
            socketProvider.connectToSocket(context);
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          } else {
            if (data.message == '1') {
              showToast(message: appLoc.registrationFailed);
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
    return Consumer<CreateProfileProvider>(builder: (context, provider, _) {
      return Form(
        key: provider.formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            CustomTextField(
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                FilteringTextInputFormatter.deny(RegExp("[0-9]")),
              ],
              placeholder: appLoc.firstName,
              controller: Provider.of<CreateProfileProvider>(context)
                  .firstNameController,
              fieldValidator: (val) {
                if (val == '') {
                  return appLoc.mustNotEmpty;
                }
                return null;
              },
            ),
            CustomTextField(
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                FilteringTextInputFormatter.deny(RegExp("[0-9]")),
              ],
              placeholder: appLoc.lastName,
              controller: Provider.of<CreateProfileProvider>(context)
                  .lastNameController,
              fieldValidator: (val) {
                if (val == '') {
                  return appLoc.mustNotEmpty;
                }
                return null;
              },
            ),
            CustomTextField(
              inputType: TextInputType.phone,
              placeholder: "Mobile Number",
              controller:
                  Provider.of<CreateProfileProvider>(context).phoneController,
              fieldValidator: (val) {
                if (val == '') {
                  return appLoc.mustNotEmpty;
                }
                return null;
              },
            ),
            InkWell(
              onTap: () {},
              child: CustomTextField(
                fieldValidator: (val) {
                  if (val == '') {
                    return appLoc.mustNotEmpty;
                  }
                  return null;
                },
                readOnly: true,
                placeholder: appLoc.country,
                controller: provider.selectedCountry,
                // suffixWidget: InkWell(
                //     onTap: () {
                //       showCountryPicker(
                //         context: context,
                //         exclude: ['KN', 'MF'],
                //         onSelect: (Country country) {
                //           provider.updateCountry(
                //             value: country.displayNameNoCountryCode,
                //           );
                //           logMe(
                //               'Select country: ${country.displayNameNoCountryCode}');
                //         },
                //         countryListTheme: CountryListThemeData(
                //           // Optional. Sets the border radius for the bottomsheet.
                //           borderRadius: const BorderRadius.only(
                //             topLeft: Radius.circular(40.0),
                //             topRight: Radius.circular(40.0),
                //           ),
                //           // Optional. Styles the search field.
                //           inputDecoration: InputDecoration(
                //             labelText: 'Search',
                //             hintText: 'Start typing to search',
                //             prefixIcon: const Icon(Icons.search),
                //             border: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: const Color(0xFF8C98A8).withOpacity(0.2),
                //               ),
                //             ),
                //           ),
                //           // Optional. Styles the text in the search field
                //           searchTextStyle: const TextStyle(
                //             color: Colors.blue,
                //             fontSize: 18,
                //           ),
                //         ),
                //       );
                //     },
                //     child: Image.asset(dropdownIcon)),
                // fieldValidator: (val) {
                //   if (val == '') {
                //     return appLoc.mustNotEmpty;
                //   }
                //   return null;
                // },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomButton(
              text: Text(
                appLoc.saveDetails,
                style: TextStyle(
                  fontFamily: 'poPPinSemiBold',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              buttonHeight: 50,
              isRounded: true,
              event: () {
                // uploadProfileImage();
                var imagePath =
                    Provider.of<CreateProfileProvider>(context, listen: false)
                        .imageFilePath
                        .toString();

                if (provider.formKey.currentState!.validate()) {
                  if (imagePath.isEmpty) {
                    log("No Image Picked");
                    saveDetails('');
                  } else {
                    uploadProfileImage();
                  }
                }

                // logMe("Image File Path====>$imagePath");
                // if (provider.formKey.currentState!.validate()) {
                //   saveDetails();
                // }
              },
              bgColor: black080809Color,
            ),
          ],
        ),
      );
    });
  }
}
