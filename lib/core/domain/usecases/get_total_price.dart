import 'package:GetsbyRideshare/core/domain/entities/total_price.dart';
import 'package:GetsbyRideshare/core/domain/repositories/total_price_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

abstract class GetTotalPriceUseCase<Type> {
  Future<Either<Failure, TotalPrice>> call(
      String kategoriId, String distance, String night);
}

class GetTotalPrice implements GetTotalPriceUseCase {
  TotalPriceRepository repository;

  GetTotalPrice(this.repository);

  @override
  Future<Either<Failure, TotalPrice>> call(
      String categoryId, String distance, String night) async {
    return await repository.getTotalPrice(categoryId, distance, night);
  }
}
