import 'dart:developer';

import 'package:GetsbyRideshare/core/utility/extension.dart';
import 'package:GetsbyRideshare/features/profile/data/models/edit_profile_response_model.dart';
import 'package:dio/dio.dart';

abstract class CreateProfileDataSource {
  Future<EditProfileResponseModel> createProfile(FormData formData);
}

class CreateProfileDataSourceImplementation implements CreateProfileDataSource {
  final Dio dio;

  CreateProfileDataSourceImplementation({required this.dio});

  @override
  Future<EditProfileResponseModel> createProfile(FormData formData) async {
    String url = "api/webservice/customer/create/profile";
    dio.withToken();

    log("create profile formdata is:${formData.fields} ");
    try {
      final response = await dio.post(url, data: formData);
      final model = EditProfileResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
