import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/history_data_source.dart';
import '../models/history_response_model.dart';
import '../models/rating_response_modal.dart';

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

  @override
  Future<Either<Failure, GetRatingResponseModal>> getRatings(
      FormData formData) async {
    try {
      final data = await dataSource.getRatings(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure Submit Ratings repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }


}
