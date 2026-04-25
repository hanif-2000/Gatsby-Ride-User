import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/forgot_password_response_model.dart';
import '../repositories/forgot_password_repository.dart';

abstract class UpdatePasswordUseCase<Type> {
  Future<Either<Failure, ForgotPasswordResponseModel>> execute(Map<String, dynamic> data);
}

class UpdatePassword implements UpdatePasswordUseCase<String> {
  final ForgotPasswordRepository repository;

  UpdatePassword({required this.repository});

  @override
  Future<Either<Failure, ForgotPasswordResponseModel>> execute(
      Map<String, dynamic> data) async {
    final result = await repository.updatePassword(data);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
