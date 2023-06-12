import 'package:appkey_taxiapp_user/features/forgot_password/data/models/otp_verification_response_modal.dart';
import 'package:appkey_taxiapp_user/features/forgot_password/domain/repositories/otp_verification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

abstract class OtpVerificationUserCases<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, OtpVerificationResponseModal>> call(FormData formData);
}

class DoOtpVerify implements OtpVerificationUserCases<String> {
  final OtpVerificationRepository repository;

  DoOtpVerify({required this.repository});

  @override
  Future<Either<Failure, OtpVerificationResponseModal>> call(
      FormData formData) async {
    final result = await repository.doOtpVerify(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
