import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/profile/domain/usecases/update_profile.dart';
import 'package:GetsbyRideshare/features/profile/presentation/providers/profile_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/presentation/providers/form_provider.dart';
import '../../data/models/profile_response_model.dart';

class ProfileEditProvider extends FormProvider {
  final UpdateProfile updateProfile;

  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';

  TextEditingController selectedCountry = TextEditingController();

  updateCountry({value}) {
    selectedCountry.text = value;

    notifyListeners();
  }

  ProfileEditProvider({required this.updateProfile});

  setupTextControllerValues(User? profile) {
    nameController.text = profile?.name ?? '';
    emailController.text = profile?.email ?? '';
    phoneController.text = profile?.phone ?? '';
    _imageUrl = profile?.photo ?? '';
    firstNameController.text = profile?.firstName ?? '';
    lastNameController.text = profile?.lastName ?? '';
    countryController.text = profile?.country ?? '';

    notifyListeners();
  }

  showPicker({context}) async {
    await showImagePicker(context: context);
  }

  Stream<ProfileState> updateProfileForm(
      {required String firstName,
      required String lastName,
      required String phone,
      required String country,
      XFile? photo}) async* {
    yield ProfileLoading();
    final data = FormData.fromMap({
      'name': '${firstName} ${lastName}',
      'first_name': firstName,
      'phone': phone,
      if (photo != null)
        'image': await MultipartFile.fromFile(photo.path, filename: photo.name),
      'last_name': lastName,
      "country": selectedCountry.text
    });
    final result = await updateProfile.execute(data);
    yield* result.fold((failure) async* {
      logMe("Failureeeee");

      yield ProfileFailure(failure: failure.message);
    }, (data) async* {
      logMe("loadeddd");

      yield ProfileUpdateSuccess(success: data);
    });
  }
}
