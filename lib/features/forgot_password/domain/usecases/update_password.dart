import 'package:GetsbyRideshare/core/error/failure.dart';
import 'package:GetsbyRideshare/features/forgot_password/data/models/forgot_password_response_model.dart';
import 'package:GetsbyRideshare/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class UpdatePasswordUseCase<Type> {
  Future<Either<Failure, ForgotPasswordResponseModel>> execute(
      FormData formData);
}

class UpdatePassword implements UpdatePasswordUseCase<String> {
  final ForgotPasswordRepository repository;

  UpdatePassword({required this.repository});

  @override
  Future<Either<Failure, ForgotPasswordResponseModel>> execute(
      FormData formData) async {
    final result = await repository.updatePassword(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
