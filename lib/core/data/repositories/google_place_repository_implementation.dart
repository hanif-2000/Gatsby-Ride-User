import 'package:dartz/dartz.dart';

import '../../domain/repositories/google_place_repository.dart';
import '../../error/failure.dart';
import '../../network/network_info.dart';
import '../datasources/place_text_search_datasource.dart';
import '../models/google_place_model.dart';

class GooglePlaceRepositoryImpl implements GooglePlaceRepository {
  final GooglePlaceDataSource dataSource;
  final NetworkInfo networkInfo;

  GooglePlaceRepositoryImpl(
      {required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<GooglePlaceSearchModel>>> getGooglePlace(
      String query) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getGooglePlace(query);
        return Right(result);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(ConnectionFailure());
    }
  }
}
