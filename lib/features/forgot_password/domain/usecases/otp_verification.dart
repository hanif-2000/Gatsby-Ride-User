import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/otp_verification_response_modal.dart';
import '../repositories/otp_verification_repository.dart';

abstract class OtpVerificationUserCases<Type> {
  Future<Either<Failure, OtpVerificationResponseModal>> call(Map<String, dynamic> data);
}

class DoOtpVerify implements OtpVerificationUserCases<String> {
  final OtpVerificationRepository repository;

  DoOtpVerify({required this.repository});

  @override
  Future<Either<Failure, OtpVerificationResponseModal>> call(
      Map<String, dynamic> data) async {
    final result = await repository.doOtpVerify(data);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
