import 'package:appkey_taxiapp_user/features/order/data/models/create_order_response_model.dart';
import 'package:appkey_taxiapp_user/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

abstract class CreateOrderUseCase<Type> {
  Future<Either<Failure, CreateOrderResponseModel>> execute(FormData formData);
}

class CreateOrder implements CreateOrderUseCase<String> {
  final OrderRepository repository;

  CreateOrder({required this.repository});

  @override
  Future<Either<Failure, CreateOrderResponseModel>> execute(
      FormData formData) async {
    final result = await repository.createOrder(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
