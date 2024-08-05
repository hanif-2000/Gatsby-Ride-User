import 'package:dio/dio.dart';
import '../../utility/app_settings.dart';
import '../../utility/injection.dart';
import '../models/google_place_model.dart';
import '../../../../core/utility/extension.dart';
import '../models/google_place_model_response.dart';

abstract class GooglePlaceDataSource {
  Future<List<GooglePlaceSearchModel>> getGooglePlace(String query);
}

class GooglePlaceDataSourceImpl implements GooglePlaceDataSource {
  final Dio dio;

  GooglePlaceDataSourceImpl({required this.dio});
  @override
  Future<List<GooglePlaceSearchModel>> getGooglePlace(String query) async {
    String path;

    if (myLocale.languageCode == 'ja') {
      path =
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&language=ja&components=country:ca|country:in&key=$GOOGLEMAPKEY';
    } else {
      path 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&components=country:ca|country:in&key=$GOOGLEMAPKEY';
    }

    dio.withToken();
    try {
      final result = await dio.get(path);
      return GooglePlaceSearchModelResponse.fromJson(result.data).results;
    } catch (e) {
      rethrow;
    }
  }
}
