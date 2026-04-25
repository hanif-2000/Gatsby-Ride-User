import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/otp_verification_response_modal.dart';

abstract class OtpVerificationRepository {
  Future<Either<Failure, OtpVerificationResponseModal>> doOtpVerify(
      Map<String, dynamic> data);
}
