import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../datasources/forgot_password_data_source.dart';
import '../models/forgot_password_response_model.dart';

class ForgotPasswordRepositoryImplementation
    implements ForgotPasswordRepository {
  final ForgotPasswordDataSource dataSource;

  ForgotPasswordRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, ForgotPasswordResponseModel>> doForgotPassword(
      FormData formData) async {
    try {
      final data = await dataSource.doForgotPassword(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure ForgotPassword repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordResponseModel>> updatePassword(
      FormData formData) async {
    try {
      final data = await dataSource.updatePassword(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordResponseModel>> verifyOtp(
      FormData formData) async {
    try {
      final data = await dataSource.verifyOtp(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
