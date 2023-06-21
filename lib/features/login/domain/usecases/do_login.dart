import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/login_response_model.dart';
import '../repositories/login_repository.dart';

abstract class LoginUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, LoginResponseModel?>> call(
      String email, String password);
}

class DoLogin implements LoginUseCase<String> {
  final LoginRepository repository;

  DoLogin({required this.repository});

  @override
  Future<Either<Failure, LoginResponseModel?>> call(
      String email, String password) async {
    final result = await repository.doLogin(email, password);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
