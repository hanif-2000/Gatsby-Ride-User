import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/new_card_payment/data/datasources/payment_data_source.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/add_card_response_modal.dart';
import '../models/card_list_response_modal.dart';

class PaymentRepositoryImplementation implements PaymentRepository {
  final PaymentDataSource dataSource;

  PaymentRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, CardListResponseModal>> getCardDetails() async {
    try {
      final data = await dataSource.getCardDetails();
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure GetCardDetails repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, AddCardResponseModal>> addCardDetails(
      FormData formData) async {
    try {
      final data = await dataSource.addCardDetails(formData);
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, AddCardResponseModal>> deleteCard(FormData formData) async{
    try {
      final data = await dataSource.deleteCard(formData);
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

}
