import 'package:GetsbyRideshare/core/utility/extension.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/profile/data/models/edit_profile_response_model.dart';
import 'package:dio/dio.dart';

import '../models/profile_response_model.dart';

abstract class ProfileDataSource {
  Future<User> getProfile();
  Future<int> updateProfile(FormData formData);
  Future<int> updateEmail(FormData formData);
  Future<EditProfileResponseModel> updatePassword(FormData formData);
}

class ProfileDataSourceImplementation implements ProfileDataSource {
  final Dio dio;

  ProfileDataSourceImplementation({required this.dio});

//Get Profile data with bearer token
  @override
  Future<User> getProfile() async {
    String url = 'api/webservice/user_profile';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );

      if ((response.data["success"] == 0) &&
          (response.data["message"] == "Account Suspended")) {
        showToast(message: "Account Suspended");
      }
      final model = ProfileResponseModel.fromJson(response.data);

      return model.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateProfile(FormData formData) async {
    String url = 'api/webservice/edit_profile_user';
    dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = EditProfileResponseModel.fromJson(response.data);
      return model.success;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateEmail(FormData formData) async {
    String url = 'api/webservice/update-email-user';
    dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = EditProfileResponseModel.fromJson(response.data);
      return model.success;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EditProfileResponseModel> updatePassword(FormData formData) async {
    // String url = 'api/webservice/update-password-user';
    String url = '                         ';
    dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = EditProfileResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
