import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/forgot_password_response_model.dart';
import '../repositories/forgot_password_repository.dart';

abstract class ForgotPasswordUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, ForgotPasswordResponseModel>> call(FormData formData);
}

class DoForgotPassword implements ForgotPasswordUseCase<String> {
  final ForgotPasswordRepository repository;

  DoForgotPassword({required this.repository});

  @override
  Future<Either<Failure, ForgotPasswordResponseModel>> call(
      FormData formData) async {
    final result = await repository.doForgotPassword(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
