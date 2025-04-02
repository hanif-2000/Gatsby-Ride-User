import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/login_response_model.dart';
import '../repositories/login_repository.dart';

abstract class LoginUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, LoginResponseModel?>> call(
    String email,
    String password,
    String loginType,
    String deviceType,
  );

  Future<Either<Failure, LoginResponseModel?>> callSocial(
    String email,
    String firstName,
    String lastName,
    String loginType,
    String deviceType,
    String socialId,
  );
}

class DoLogin implements LoginUseCase<String> {
  final LoginRepository repository;

  DoLogin({required this.repository});

  @override
  Future<Either<Failure, LoginResponseModel?>> call(
    String email,
    String password,
    String loginType,
    String deviceType,
  ) async {
    final result = await repository.doLogin(
      email,
      password,
      loginType,
      deviceType,
    );
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }

  @override
  Future<Either<Failure, LoginResponseModel?>> callSocial(
    String email,
    String firstName,
    String lastName,
    String loginType,
    String deviceType,
    String socialId,
  ) async {
    final result = await repository.doLoginSocial(
      email,
      firstName,
      lastName,
      loginType,
      deviceType,
      socialId,
    );
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
