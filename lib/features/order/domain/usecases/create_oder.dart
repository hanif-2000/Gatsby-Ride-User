import 'package:GetsbyRideshare/features/order/data/models/create_order_response_model.dart';
import 'package:GetsbyRideshare/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class CreateOrderUseCase<Type> {
  Future<Either<Failure, CreateOrderResponseModel>> execute(Map<String, dynamic> data);
}

class CreateOrder implements CreateOrderUseCase<String> {
  final OrderRepository repository;

  CreateOrder({required this.repository});

  @override
  Future<Either<Failure, CreateOrderResponseModel>> execute(
      Map<String, dynamic> data) async {
    final result = await repository.createOrder(data);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
