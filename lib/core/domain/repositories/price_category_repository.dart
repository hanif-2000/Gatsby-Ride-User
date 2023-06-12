import 'package:appkey_taxiapp_user/core/domain/entities/price_category_list.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

abstract class PriceCategoryRepository {
  Future<Either<Failure, PriceCategoryList>> getPriceCategoryList();
}
