import 'dart:developer';

import 'package:GetsbyRideshare/core/domain/entities/currency.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
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
      showToast(message: "Please Check your connection");
      return const Left(ConnectionFailure());
    } else if (await networkInfo.isSlow) {
      showToast(message: "Network is Slow");
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
