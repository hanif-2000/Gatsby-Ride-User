import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../repositories/profile_repository.dart';

abstract class UpdateEmailUseCase<Type> {
  Future<Either<Failure, int>> execute(FormData formData);
}

class UpdateEmail implements UpdateEmailUseCase<String> {
  final ProfileRepository repository;

  UpdateEmail({required this.repository});

  @override
  Future<Either<Failure, int>> execute(FormData formData) async {
    final result = await repository.updateEmail(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
