import 'package:GetsbyRideshare/core/static/enums.dart';
import 'package:GetsbyRideshare/features/contact_us/data/models/contactus_response_modal.dart';
import 'package:dio/dio.dart';

abstract class ContactUsDataSource {
  Future<ContactUsResponseModel> doContactUs(FormData formData);
}

class ContactUsDataSourceImplementation implements ContactUsDataSource {
  final Dio dio;

  ContactUsDataSourceImplementation({required this.dio});

  @override
  Future<ContactUsResponseModel> doContactUs(FormData formData) async {
    String url = 'api/webservice/contactUs';
    dio.withToken();

    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = ContactUsResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
