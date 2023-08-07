import 'package:GetsbyRideshare/features/order/domain/entities/order_detail.dart';
import 'package:GetsbyRideshare/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class GetOrderDetailUseCase<Type> {
  Future<Either<Failure, OrderDetail>> call();
}

class GetOrderDetail implements GetOrderDetailUseCase {
  final OrderRepository repository;

  GetOrderDetail({required this.repository});

  @override
  Future<Either<Failure, OrderDetail>> call() async {
    return await repository.getDetailOrder();
  }
}
