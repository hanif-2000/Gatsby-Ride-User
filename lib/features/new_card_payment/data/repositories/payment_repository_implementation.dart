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
    } on DioError catch (e) {
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
    } on DioError catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, AddCardResponseModal>> deleteCardD(FormData formData) async{
    try {
      final data = await dataSource.addCardDetails(formData);
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure profile repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  // @override
  // Future<Either<Failure, int>> updateProfile(FormData formData) async {
  //   try {
  //     final data = await dataSource.updateProfile(formData);
  //     return Right(data);
  //   } on DioError catch (e) {
  //     logMe("Failure profile repository ${e.toString()}");
  //     return Left(ServerFailure(message: e.message));
  //   }
  // }

  // @override
  // Future<Either<Failure, int>> updateEmail(FormData formData) async {
  //   try {
  //     final data = await dataSource.updateEmail(formData);
  //     return Right(data);
  //   } on DioError catch (e) {
  //     logMe("Failure profile repository ${e.toString()}");
  //     return Left(ServerFailure(message: e.message));
  //   }
  // }

  // @override
  // Future<Either<Failure, EditProfileResponseModel>> updatePassword(
  //     FormData formData) async {
  //   try {
  //     final data = await dataSource.updatePassword(formData);
  //     return Right(data);
  //   } on DioError catch (e) {
  //     logMe("Failure profile repository ${e.toString()}");
  //     return Left(ServerFailure(message: e.message));
  //   }
  // }
}
