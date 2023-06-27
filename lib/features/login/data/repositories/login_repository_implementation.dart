import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_data_source.dart';
import '../models/login_response_model.dart';

class LoginRepositoryImplementation implements LoginRepository {
  final LoginDataSource dataSource;

  LoginRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, LoginResponseModel?>> doLogin(
    String email,
    String password,
    String loginType,
    String deviceType,
  ) async {
    try {
      final data = await dataSource.doLogin(
        email,
        password,
        loginType,
        deviceType,
      );
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure login repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel?>> doLoginSocial(
    String email,
    String firstName,
    String loginType,
    String deviceType,
    String lastName,
  ) async {
    try {
      final data = await dataSource.doLoginSocial(
        email,
        firstName,
        lastName,
        loginType,
        deviceType,
      );
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure login repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
