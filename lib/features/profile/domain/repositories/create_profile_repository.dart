import 'package:GetsbyRideshare/core/error/failure.dart';
import 'package:GetsbyRideshare/features/profile/data/models/edit_profile_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class CreateProfileRepository {
  Future<Either<Failure, EditProfileResponseModel>> createProfile(
      FormData formData);
}

abstract class UploadProfileImageRepository {
  Future<Either<Failure, EditProfileResponseModel>> uploadProfileImage(
      FormData formData);
}
