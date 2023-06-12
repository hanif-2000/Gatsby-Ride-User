import 'package:appkey_taxiapp_user/features/about_us/data/models/aboutus_response_model.dart';
import 'package:dio/dio.dart';

abstract class AboutUsDataSource {
  Future<AboutUsDataModel?> getAboutUs();
}

class AboutUsDataSourceImplementation implements AboutUsDataSource {
  final Dio dio;

  AboutUsDataSourceImplementation({required this.dio});

  @override
  Future<AboutUsDataModel?> getAboutUs() async {
    String url = 'api/webservice/about-us';

    try {
      final response = await dio.get(
        url,
      );
      final model = AboutUsResponseModel.fromJson(response.data);
      if (model.data != null) {
        return model.data;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
