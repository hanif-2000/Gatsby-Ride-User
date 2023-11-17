import 'package:GetsbyRideshare/core/error/failure.dart';
import 'package:GetsbyRideshare/features/forgot_password/data/models/otp_verification_response_modal.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class OtpVerificationRepository {
  Future<Either<Failure, OtpVerificationResponseModal>> doOtpVerify(
      FormData formData);
}
