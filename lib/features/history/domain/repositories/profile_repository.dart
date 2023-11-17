import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/history_response_model.dart';
import '../../data/models/rating_response_modal.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<HistoryOrder>>> getHistory();
  Future<Either<Failure, GetRatingResponseModal>> getRatings(FormData formData);
}
