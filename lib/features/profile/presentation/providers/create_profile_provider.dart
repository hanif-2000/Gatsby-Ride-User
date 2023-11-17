import 'package:GetsbyRideshare/features/profile/domain/usecases/create_profile.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/create_profile_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/providers/form_provider.dart';

class CreateProfileProvider extends FormProvider {
  final CreateProfile doCreateProfile;
  // final DoOtpVerify doOtpVerify;

  CreateProfileProvider({required this.doCreateProfile});

  TextEditingController selectedCountry = TextEditingController(text: "Canada");

  bool isImageUploaded = false;

  Stream<CreateProfileState> doCreateProfileApi(profileImage) async* {
    //show loader
    yield CreateProfileLoading();

    //If Profile Images uploaded

    //formdata
    final formData = FormData.fromMap({
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'phone': phoneController.text,
      'country': "Canada",
      'image': profileImage
    });
    final result = await doCreateProfile.execute(formData);
    yield* result.fold((statusCode) async* {
      yield CreateProfileFailure(failure: statusCode.message);
    }, (result) async* {
      yield CreateProfileSuccess(data: result);
    });
  }

  updateCountry({value}) {
    selectedCountry.text = value;

    notifyListeners();
  }

  showPicker({context}) async {
    await showImagePicker(context: context);
  }

  toogleIsImageUploaded() {
    isImageUploaded = true;
    notifyListeners();
  }
}
