import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../data/models/profile_response_model.dart';
import '../../domain/usecases/get_profile.dart';
import 'profile_state.dart';

class ProfileProvider extends FormProvider {
  final GetProfile getProfile;

  User? _profile;
  bool _isLoadProfile = true;
  User? get profile => _profile;
  bool get isLoadProfile => _isLoadProfile;

  set profile(User? data) {
    _profile = data;
    _isLoadProfile = false;
    notifyListeners();
  }

  ProfileProvider({required this.getProfile});

  Stream<ProfileState> fetchProfile() async* {
    logMe("loading");

    yield ProfileLoading();
    final result = await getProfile();
    yield* result.fold((failure) async* {
      logMe("error");
      logMe(failure);
      yield ProfileFailure(failure: failure.message);
    }, (data) async* {
      logMe("loadedddd");
      yield ProfileLoaded(data: data);
    });
  }

  setProfileData() async {
    fetchProfile().listen((state) {
      if (state is ProfileLoaded) {
        final data = state.data;
        profile = data;
      }
    });
  }

  refreshProfile() async {
    logMe("refresh");
    notifyListeners();
  }
}
