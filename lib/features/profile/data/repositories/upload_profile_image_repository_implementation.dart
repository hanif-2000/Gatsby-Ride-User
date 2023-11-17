import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/profile/data/datasources/upload_profile_image_data_source.dart';
import 'package:GetsbyRideshare/features/profile/domain/repositories/create_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../models/edit_profile_response_model.dart';

class UploadProfileImageRepositoryImplementation
    implements UploadProfileImageRepository {
  final UploadProfileImageDataSource dataSource;

  UploadProfileImageRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, EditProfileResponseModel>> uploadProfileImage(
      FormData formData) async {
    try {
      final data = await dataSource.uploadProfileImage(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
