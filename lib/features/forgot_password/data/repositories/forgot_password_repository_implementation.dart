import 'package:GetsbyRideshare/core/utility/helper.dart';
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
      Map<String, dynamic> data) async {
    try {
      final result = await dataSource.doForgotPassword(data);
      return Right(result);
    } on DioException catch (e) {
      logMe("Failure ForgotPassword repository ${e.toString()}");
      final serverMessage = e.response?.data is Map
          ? (e.response!.data['message'] as String? ?? 'Something went wrong')
          : 'Something went wrong';
      return Left(ServerFailure(message: serverMessage));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordResponseModel>> updatePassword(
      Map<String, dynamic> data) async {
    try {
      final result = await dataSource.updatePassword(data);
      return Right(result);
    } on DioException catch (e) {
      logMe("Failure updatePassword repository ${e.toString()}");
      final serverMessage = e.response?.data is Map
          ? (e.response!.data['message'] as String? ?? 'Something went wrong')
          : 'Something went wrong';
      return Left(ServerFailure(message: serverMessage));
    }
  }

  @override
  Future<Either<Failure, ForgotPasswordResponseModel>> verifyOtp(
      Map<String, dynamic> data) async {
    try {
      final result = await dataSource.verifyOtp(data);
      return Right(result);
    } on DioException catch (e) {
      logMe("Failure verifyOtp repository ${e.toString()}");
      final serverMessage = e.response?.data is Map
          ? (e.response!.data['message'] as String? ?? 'Something went wrong')
          : 'Something went wrong';
      return Left(ServerFailure(message: serverMessage));
    }
  }
}
