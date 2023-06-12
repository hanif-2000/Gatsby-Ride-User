import 'package:appkey_taxiapp_user/features/order/data/models/create_order_response_model.dart';
import 'package:appkey_taxiapp_user/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/status_oder_response_model.dart';

abstract class UpdateStatusOrderUseCase<Type> {
  Future<Either<Failure, UpdateStatusOrderResponseModel>> execute(
      FormData formData);
}

class UpdateStatusOrder implements UpdateStatusOrderUseCase<String> {
  final OrderRepository repository;

  UpdateStatusOrder({required this.repository});

  @override
  Future<Either<Failure, UpdateStatusOrderResponseModel>> execute(
      FormData formData) async {
    final result = await repository.updateStatusOrder(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
