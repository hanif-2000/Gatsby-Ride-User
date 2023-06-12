import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/edit_profile_response_model.dart';
import '../../data/models/profile_response_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, int>> updateProfile(FormData formData);
  Future<Either<Failure, int>> updateEmail(FormData formData);
  Future<Either<Failure, EditProfileResponseModel>> updatePassword(
      FormData formData);
}
