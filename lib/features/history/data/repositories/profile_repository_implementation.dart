import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/history_data_source.dart';
import '../models/history_response_model.dart';

class HistoryRepositoryImplementation implements HistoryRepository {
  final HistoryDataSource dataSource;

  HistoryRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, List<HistoryOrder>>> getHistory() async {
    try {
      final data = await dataSource.getHistory();
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure History repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
