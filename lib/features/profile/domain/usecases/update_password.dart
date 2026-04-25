import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/edit_profile_response_model.dart';
import '../repositories/profile_repository.dart';

abstract class UpdatePasswordUseCase<Type> {
  Future<Either<Failure, EditProfileResponseModel>> execute(Map<String, dynamic> data);
}

class UpdatePassword implements UpdatePasswordUseCase<String> {
  final ProfileRepository repository;

  UpdatePassword({required this.repository});

  @override
  Future<Either<Failure, EditProfileResponseModel>> execute(
      Map<String, dynamic> data) async {
    final result = await repository.updatePassword(data);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
