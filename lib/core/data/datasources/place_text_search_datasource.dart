import 'package:dio/dio.dart';
import '../../utility/app_settings.dart';
import '../../utility/injection.dart';
import '../models/google_place_model.dart';
import '../../../../core/utility/extension.dart';
import '../models/google_place_model_response.dart';

abstract class GooglePlaceDataSource {
  Future<List<GooglePlaceSearchModel>> getGooglePlace(String query);
  Future<List<GooglePlaceSearchModel>> getGooglePlaceNearBy(String query,double latitude, double longitude);
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
      path = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&components=country:ca|country:in&key=$GOOGLEMAPKEY';
    }

    dio.withToken();
    try {
      final result = await dio.get(path);
      return GooglePlaceSearchModelResponse.fromJson(result.data).results;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GooglePlaceSearchModel>> getGooglePlaceNearBy(String query, double latitude, double longitude) async {
    String pathTextSearch, pathNearbySearch;

    // Text search with language handling
    if (myLocale.languageCode == 'ja') {
      pathTextSearch = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&language=ja&components=country:ca|country:in&key=$GOOGLEMAPKEY';
    } else {
      pathTextSearch = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&components=country:ca|country:in&key=$GOOGLEMAPKEY';
    }
    pathNearbySearch= "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=$query&location=$latitude,$longitude&radius=50000&type=establishment&key=$GOOGLEMAPKEY";
    dio.withToken();
    try {
      final nearbyResult = await dio.get(pathNearbySearch);
      List<GooglePlaceSearchModel> nearbyPlaces = GooglePlaceSearchModelResponse.fromJson(nearbyResult.data).results;
      if (nearbyPlaces.isEmpty) {
        final textResult = await dio.get(pathTextSearch);
        List<GooglePlaceSearchModel> textSearchPlaces = GooglePlaceSearchModelResponse.fromJson(textResult.data).results;
        nearbyPlaces.addAll(textSearchPlaces.where((place) => !nearbyPlaces.any((nearbyPlace) => nearbyPlace.place_id == place.place_id)));
      }
      return nearbyPlaces;
    } catch (e,s) {
      print("$e,$s");
      rethrow;
    }
  }
}
