import 'package:appkey_taxiapp_user/features/order/data/models/driver_location_response_model.dart';
import 'package:appkey_taxiapp_user/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class GetDriverLocationUseCase<Type> {
  Future<Either<Failure, DriverLocationResponseModel>> call();
}

class GetDriverLocation implements GetDriverLocationUseCase {
  OrderRepository repository;

  GetDriverLocation({required this.repository});

  @override
  Future<Either<Failure, DriverLocationResponseModel>> call() async {
    return await repository.getDriverLocation();
  }
}
