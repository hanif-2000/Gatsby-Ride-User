import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/register_response_model.dart';
import '../repositories/register_repository.dart';

abstract class RegisterUseCase<Type> {
  Future<Either<Failure, RegisterResponseModel>> call(Map<String, dynamic> data);
}

class DoRegister implements RegisterUseCase<String> {
  final RegisterRepository repository;

  DoRegister({required this.repository});

  @override
  Future<Either<Failure, RegisterResponseModel>> call(Map<String, dynamic> data) async {
    final result = await repository.doRegister(data);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
