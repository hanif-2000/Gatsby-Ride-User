import 'package:appkey_taxiapp_user/features/about_us/data/models/aboutus_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/history_response_model.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<HistoryOrder>>> getHistory();
}
