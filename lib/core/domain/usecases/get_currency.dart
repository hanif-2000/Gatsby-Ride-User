import 'package:appkey_taxiapp_user/core/domain/entities/currency.dart';
import 'package:appkey_taxiapp_user/core/domain/repositories/currency_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

abstract class GetCurrencyUseCase<Type> {
  Future<Either<Failure, Currency>> call();
}

class GetCurrency implements GetCurrencyUseCase {
  CurrencyRepository repository;

  GetCurrency(this.repository);

  @override
  Future<Either<Failure, Currency>> call() async {
    return await repository.getCurrency();
  }
}
