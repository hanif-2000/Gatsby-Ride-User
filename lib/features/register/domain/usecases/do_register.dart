import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/register_response_model.dart';
import '../repositories/register_repository.dart';

abstract class RegisterUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, RegisterResponseModel>> call(FormData formData);
}

class DoRegister implements RegisterUseCase<String> {
  final RegisterRepository repository;

  DoRegister({required this.repository});

  @override
  Future<Either<Failure, RegisterResponseModel>> call(FormData formData) async {
    final result = await repository.doRegister(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
