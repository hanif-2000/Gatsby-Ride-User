import 'package:GetsbyRideshare/core/data/datasources/price_category_datasource.dart';
import 'package:GetsbyRideshare/core/domain/entities/price_category_list.dart';
import 'package:GetsbyRideshare/core/domain/repositories/price_category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';
import '../../network/network_info.dart';
import '../../utility/helper.dart';

class PriceCategoryRepositoryImplementation implements PriceCategoryRepository {
  final PriceCategoryDataSource dataSource;
  final NetworkInfo networkInfo;

  PriceCategoryRepositoryImplementation({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PriceCategoryList>> getPriceCategoryList(
    String distance,
    String nightService,
    String coordinates,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectionFailure());
    } else if (await networkInfo.isSlow) {
      showToast(message: "Network is Slow");
    }

    try {
      final response = await dataSource.getPriceCategoryList(
          distance, nightService, coordinates);
      return Right(response);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
