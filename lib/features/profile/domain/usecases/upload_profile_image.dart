import 'package:appkey_taxiapp_user/features/profile/domain/repositories/create_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/edit_profile_response_model.dart';

abstract class UploadProfileImageUseCase<Type> {
  Future<Either<Failure, EditProfileResponseModel>> execute(FormData formData);
}

class UploadProfileImage implements UploadProfileImageUseCase<String> {
  final UploadProfileImageRepository repository;

  UploadProfileImage({required this.repository});

  @override
  Future<Either<Failure, EditProfileResponseModel>> execute(
      FormData formData) async {
    final result = await repository.uploadProfileImage(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
