import 'dart:developer';

import 'package:appkey_taxiapp_user/core/domain/entities/currency.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/currency_repository.dart';
import '../../error/failure.dart';
import '../../network/network_info.dart';
import '../datasources/currency_datasource.dart';

class CurrencyRepositoryImplementation implements CurrencyRepository {
  final CurrencyDataSource dataSource;
  final NetworkInfo networkInfo;

  CurrencyRepositoryImplementation({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Currency>> getCurrency() async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectionFailure());
    }

    try {
      final response = await dataSource.getCurrency();
      log(response.toString());
      return Right(response);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
