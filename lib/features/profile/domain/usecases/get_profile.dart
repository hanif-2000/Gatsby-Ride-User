import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/profile_response_model.dart';
import '../repositories/profile_repository.dart';

abstract class ProfileUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, User>> call();
}

class GetProfile implements ProfileUseCase<String> {
  final ProfileRepository repository;

  GetProfile({required this.repository});

  @override
  Future<Either<Failure, User>> call() async {
    final result = await repository.getProfile();
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
