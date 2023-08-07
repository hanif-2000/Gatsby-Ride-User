import 'package:GetsbyRideshare/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/submit_rating_response_modal.dart';

abstract class SubmitRatingsUseCase<Type> {
  Future<Either<Failure, SubmitRatingsResponseModel>> execute(
      FormData formData);
}

class SubmitRatings implements SubmitRatingsUseCase<String> {
  final OrderRepository repository;

  SubmitRatings({required this.repository});

  @override
  Future<Either<Failure, SubmitRatingsResponseModel>> execute(
      FormData formData) async {
    final result = await repository.submitRating(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
