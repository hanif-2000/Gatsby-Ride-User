import 'package:GetsbyRideshare/core/domain/entities/vehcles_category_list.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

abstract class VehiclesCategoryRepository {
  Future<Either<Failure, VehiclesCategoryList>> getVehiclesCategoryList(
    String distance,
    String nightService,
    String coordinates,
    String time,
  );
}
