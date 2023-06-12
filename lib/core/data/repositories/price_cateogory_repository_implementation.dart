import 'package:appkey_taxiapp_user/core/data/datasources/price_category_datasource.dart';
import 'package:appkey_taxiapp_user/core/domain/entities/price_category_list.dart';
import 'package:appkey_taxiapp_user/core/domain/repositories/price_category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';
import '../../network/network_info.dart';

class PriceCategoryRepositoryImplementation implements PriceCategoryRepository {
  final PriceCategoryDataSource dataSource;
  final NetworkInfo networkInfo;

  PriceCategoryRepositoryImplementation({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PriceCategoryList>> getPriceCategoryList() async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectionFailure());
    }

    try {
      final response = await dataSource.getPriceCategoryList();
      return Right(response);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
