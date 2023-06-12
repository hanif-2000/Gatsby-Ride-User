import 'package:dartz/dartz.dart';

import '../../error/failure.dart';
import '../entities/google_places.dart';

abstract class GooglePlaceRepository {
  Future<Either<Failure, List<GooglePlaceSearch>>> getGooglePlace(String query);
}
