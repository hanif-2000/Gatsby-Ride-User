import 'package:appkey_taxiapp_user/core/domain/entities/currency.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, Currency>> getCurrency();
}
