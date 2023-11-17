import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_data_source.dart';
import '../models/edit_profile_response_model.dart';
import '../models/profile_response_model.dart';

class ProfileRepositoryImplementation implements ProfileRepository {
  final ProfileDataSource dataSource;

  ProfileRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final data = await dataSource.getProfile();
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, int>> updateProfile(FormData formData) async {
    try {
      final data = await dataSource.updateProfile(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, int>> updateEmail(FormData formData) async {
    try {
      final data = await dataSource.updateEmail(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, EditProfileResponseModel>> updatePassword(
      FormData formData) async {
    try {
      final data = await dataSource.updatePassword(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
