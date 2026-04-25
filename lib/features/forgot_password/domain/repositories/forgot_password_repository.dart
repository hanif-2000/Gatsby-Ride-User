import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/forgot_password_response_model.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, ForgotPasswordResponseModel>> doForgotPassword(
      Map<String, dynamic> data);

  Future<Either<Failure, ForgotPasswordResponseModel>> updatePassword(
      Map<String, dynamic> data);

  Future<Either<Failure, ForgotPasswordResponseModel>> verifyOtp(
      Map<String, dynamic> data);
}
