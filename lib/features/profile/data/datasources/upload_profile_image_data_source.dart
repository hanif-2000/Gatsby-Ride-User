import 'package:GetsbyRideshare/features/profile/data/models/edit_profile_response_model.dart';
import 'package:dio/dio.dart';

abstract class UploadProfileImageDataSource {
  Future<EditProfileResponseModel> uploadProfileImage(FormData formData);
}

class UploadProfileImageDataSourceImplementation
    implements UploadProfileImageDataSource {
  final Dio dio;

  UploadProfileImageDataSourceImplementation({required this.dio});

  @override
  Future<EditProfileResponseModel> uploadProfileImage(FormData formData) async {
    String url = "api/webservice/customerUpload";
    // dio.withToken();

    try {
      final response = await dio.post(url,
          data: formData,
          options: Options(
            headers: {'Content-Type': 'multipart/form-data'},
          ));

      final model = EditProfileResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
