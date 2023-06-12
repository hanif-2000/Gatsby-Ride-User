import 'package:appkey_taxiapp_user/core/domain/entities/total_price.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

abstract class TotalPriceRepository {
  Future<Either<Failure, TotalPrice>> getTotalPrice(
      String kategoriId, String distance, String night);
}
