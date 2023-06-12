import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/history_response_model.dart';
import '../repositories/profile_repository.dart';

abstract class HistoryUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, List<HistoryOrder>>> call();
}

class GetHistory implements HistoryUseCase<String> {
  final HistoryRepository repository;

  GetHistory({required this.repository});

  @override
  Future<Either<Failure, List<HistoryOrder>>> call() async {
    final result = await repository.getHistory();
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
