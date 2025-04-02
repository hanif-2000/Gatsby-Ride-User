import 'package:dartz/dartz.dart';

import '../../error/failure.dart';
import '../entities/google_places.dart';
import '../repositories/google_place_repository.dart';

class GetGooglePlace {
  final GooglePlaceRepository repository;

  GetGooglePlace({required this.repository});

  Future<Either<Failure, List<GooglePlaceSearch>>> call(String query) async {
    return await repository.getGooglePlace(query);
  }

  Future<Either<Failure, List<GooglePlaceSearch>>> callNearByApi(String query,double latitude, double longitude) async {
    return await repository.getGooglePlaceNearBy(query,latitude,longitude);
  }
}
