import 'package:appkey_taxiapp_user/core/domain/entities/price_category_list.dart';
import 'package:appkey_taxiapp_user/core/domain/repositories/price_category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

abstract class GetPriceCategoryUseCase<Type> {
  Future<Either<Failure, PriceCategoryList>> call(
    String distance,
    String nightService,
    String coordinates,
  );
}

class GetPriceCategory implements GetPriceCategoryUseCase {
  PriceCategoryRepository repository;

  GetPriceCategory(this.repository);

  @override
  Future<Either<Failure, PriceCategoryList>> call(
    String distance,
    String nightService,
    String coordinates,
  ) async {
    return await repository.getPriceCategoryList(
        distance, nightService, coordinates);
  }
}
