import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/forgot_password_response_model.dart';
import '../repositories/forgot_password_repository.dart';

abstract class ForgotPasswordUseCase<Type> {
  Future<Either<Failure, ForgotPasswordResponseModel>> call(Map<String, dynamic> data);
}

class DoForgotPassword implements ForgotPasswordUseCase<String> {
  final ForgotPasswordRepository repository;

  DoForgotPassword({required this.repository});

  @override
  Future<Either<Failure, ForgotPasswordResponseModel>> call(
      Map<String, dynamic> data) async {
    final result = await repository.doForgotPassword(data);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
