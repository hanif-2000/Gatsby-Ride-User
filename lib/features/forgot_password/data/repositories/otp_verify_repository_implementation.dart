import 'package:GetsbyRideshare/core/error/failure.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/forgot_password/data/datasources/otp_verification_data_source.dart';
import 'package:GetsbyRideshare/features/forgot_password/data/models/otp_verification_response_modal.dart';
import 'package:GetsbyRideshare/features/forgot_password/domain/repositories/otp_verification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class OtpVerifyRepositoryImplementation implements OtpVerificationRepository {
  final OtpVerificationDataSource dataSource;

  OtpVerifyRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, OtpVerificationResponseModal>> doOtpVerify(
      FormData formData) async {
    try {
      final data = await dataSource.doVerifyOtp(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure otp verification repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
