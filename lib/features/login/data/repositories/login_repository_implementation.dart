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
      String email, String password, String loginType) async {
    try {
      final data = await dataSource.doLogin(email, password, loginType);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure login repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
