import 'package:appkey_taxiapp_user/core/data/datasources/total_price_datasource.dart';
import 'package:appkey_taxiapp_user/core/domain/entities/total_price.dart';
import 'package:appkey_taxiapp_user/core/domain/repositories/total_price_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';
import '../../network/network_info.dart';

class TotalPriceRepositoryImplementation implements TotalPriceRepository {
  final TotalPriceDataSource dataSource;
  final NetworkInfo networkInfo;

  TotalPriceRepositoryImplementation({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TotalPrice>> getTotalPrice(
      String kategoriId, String distance, String night) async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectionFailure());
    }

    try {
      final response =
          await dataSource.getTotalPrice(kategoriId, distance, night);
      return Right(response);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
