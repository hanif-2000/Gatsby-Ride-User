import 'package:appkey_taxiapp_user/features/history/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/rating_response_modal.dart';

abstract class GetRatingUseCase<Type> {
  Future<Either<Failure, GetRatingResponseModal>> execute(FormData formData);
}

class GetRating implements GetRatingUseCase<String> {
  final HistoryRepository repository;

  GetRating({required this.repository});

  @override
  Future<Either<Failure, GetRatingResponseModal>> execute(
      FormData formData) async {
    final result = await repository.getRatings(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
