import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utility/helper.dart';
import '../../data/datasources/otp_verification_data_source.dart';
import '../../data/models/otp_verification_response_modal.dart';
import '../../domain/repositories/otp_verification_repository.dart';

class OtpVerifyRepositoryImplementation implements OtpVerificationRepository {
  final OtpVerificationDataSource dataSource;

  OtpVerifyRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, OtpVerificationResponseModal>> doOtpVerify(
      Map<String, dynamic> data) async {
    try {
      final result = await dataSource.doVerifyOtp(data);
      return Right(result);
    } on DioException catch (e) {
      logMe("Failure otp verification repository ${e.toString()}");
      final serverMessage = e.response?.data is Map
          ? (e.response!.data['message'] as String? ?? 'Something went wrong')
          : 'Something went wrong';
      return Left(ServerFailure(message: serverMessage));
    }
  }
}
