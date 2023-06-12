import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/profile/domain/usecases/update_profile.dart';
import 'package:appkey_taxiapp_user/features/profile/presentation/providers/profile_state.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../data/models/profile_response_model.dart';

class ProfileEditProvider extends FormProvider {
  final UpdateProfile updateProfile;

  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';

  ProfileEditProvider({required this.updateProfile});

  setupTextControllerValues(User? profile) {
    nameController.text = profile?.name ?? '';
    emailController.text = profile?.email ?? '';
    phoneController.text = profile?.phone ?? '';
    _imageUrl = profile?.photo ?? '';
    notifyListeners();
  }

  Stream<ProfileState> updateProfileForm(
      {required String name, required String phone, XFile? photo}) async* {
    yield ProfileLoading();
    final data = FormData.fromMap({
      'name': name,
      'phone': phone,
      if (photo != null)
        'image': await MultipartFile.fromFile(photo.path, filename: photo.name)
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
