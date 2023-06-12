import 'package:appkey_taxiapp_user/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/get_status_response.dart';

abstract class GetStatusOrderUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, GetStatusResponseModel>> call();
}

class GetStatusOrder implements GetStatusOrderUseCase<String> {
  final OrderRepository repository;

  GetStatusOrder({required this.repository});

  @override
  Future<Either<Failure, GetStatusResponseModel>> call() async {
    final result = await repository.getStatusOrder();
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
