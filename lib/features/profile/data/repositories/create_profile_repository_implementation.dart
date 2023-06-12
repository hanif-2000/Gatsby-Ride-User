import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/profile/data/datasources/create_profile_data_source.dart';
import 'package:appkey_taxiapp_user/features/profile/domain/repositories/create_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../models/edit_profile_response_model.dart';

class CreateProfileRepositoryImplementation implements CreateProfileRepository {
  final CreateProfileDataSource dataSource;

  CreateProfileRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, EditProfileResponseModel>> createProfile(
      FormData formData) async {
    try {
      final data = await dataSource.createProfile(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
