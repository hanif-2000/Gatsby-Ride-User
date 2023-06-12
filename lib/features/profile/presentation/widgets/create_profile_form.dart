import 'dart:developer';

import 'package:appkey_taxiapp_user/core/presentation/pages/home_page/home_page.dart';
import 'package:appkey_taxiapp_user/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/create_profile_provider.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/create_profile_state.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/upload_profile_image_provider.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/upload_profile_image_state.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/utility/helper.dart';

class CreateProfileForm extends StatefulWidget {
  const CreateProfileForm({Key? key}) : super(key: key);

  @override
  State<CreateProfileForm> createState() => _CreateProfileFormState();
}

class _CreateProfileFormState extends State<CreateProfileForm> {
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
            showToast(message: "Profile Image upload success");
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
            showToast(message: "Create profile Successfully");
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
              placeholder: "First Name",
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
              placeholder: "Last Name",
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
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const Text("This is the text showing ");
                  },
                );
              },
              child: CustomTextField(
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
                placeholder: "Country",
                controller: provider.selectedCountry,
                suffixWidget: InkWell(
                    onTap: () {
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
                                color: const Color(0xFF8C98A8).withOpacity(0.2),
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
                    },
                    child: Image.asset('assets/icons/dropdown.png')),
                fieldValidator: (val) {
                  if (val == '') {
                    return appLoc.mustNotEmpty;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomButton(
              text: const Text(
                "Save Details",
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
