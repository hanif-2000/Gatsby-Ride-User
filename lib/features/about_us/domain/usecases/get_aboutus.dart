import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utility/session_helper.dart';
import '../../data/models/aboutus_response_model.dart';
import '../repositories/aboutus_repository.dart';

abstract class AboutUsUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, AboutUsDataModel?>> call();
}

class GetAboutUs implements AboutUsUseCase<String> {
  final AboutUsRepository repository;

  GetAboutUs({required this.repository});

  @override
  Future<Either<Failure, AboutUsDataModel?>> call() async {
    final result = await repository.getAboutUs();
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
