import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../repositories/profile_repository.dart';

abstract class UpdateProfileUseCase<Type> {
  Future<Either<Failure, int>> execute(FormData formData);
}

class UpdateProfile implements UpdateProfileUseCase<String> {
  final ProfileRepository repository;

  UpdateProfile({required this.repository});

  @override
  Future<Either<Failure, int>> execute(FormData formData) async {
    final result = await repository.updateProfile(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
