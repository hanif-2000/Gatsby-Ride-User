import 'package:GetsbyRideshare/core/data/datasources/vehicles_category_datasource.dart';
import 'package:GetsbyRideshare/core/domain/entities/vehcles_category_list.dart';
import 'package:GetsbyRideshare/core/domain/repositories/vehicle_catagory_repository.dart';
import 'package:dartz/dartz.dart';

import '../../error/failure.dart';
import '../../network/network_info.dart';

class VehiclesCategoryRepositoryImplementation
    implements VehiclesCategoryRepository {
  final VehicleCategoryDataSource dataSource;
  final NetworkInfo networkInfo;

  VehiclesCategoryRepositoryImplementation({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, VehiclesCategoryList>> getVehiclesCategoryList(
    String distance,
    String nightService,
    String coordinates,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectionFailure());
    }

    try {
      final response = await dataSource.getVehiclesCategoryList(
          distance, nightService, coordinates);
      return Right(response);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
