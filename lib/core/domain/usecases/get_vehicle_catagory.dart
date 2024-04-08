import 'package:GetsbyRideshare/core/domain/entities/vehcles_category_list.dart';
import 'package:GetsbyRideshare/core/domain/repositories/vehicle_catagory_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

abstract class GetVehicleCategoryUseCase<Type> {
  Future<Either<Failure, VehiclesCategoryList>> call(
    String distance,
    String nightService,
    String coordinates,
    String time,
  );
}

class GetVehiclesCategory implements GetVehicleCategoryUseCase {
  VehiclesCategoryRepository repository;

  GetVehiclesCategory(this.repository);

  @override
  Future<Either<Failure, VehiclesCategoryList>> call(String distance,
      String nightService, String coordinates, String time) async {
    return await repository.getVehiclesCategoryList(distance, nightService, coordinates, time);
  }
}
