import 'package:GetsbyRideshare/features/profile/domain/repositories/create_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/edit_profile_response_model.dart';

abstract class CreateProfileUseCase<Type> {
  Future<Either<Failure, EditProfileResponseModel>> execute(FormData formData);
}

class CreateProfile implements CreateProfileUseCase<String> {
  final CreateProfileRepository repository;

  CreateProfile({required this.repository});

  @override
  Future<Either<Failure, EditProfileResponseModel>> execute(
      FormData formData) async {
    final result = await repository.createProfile(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
