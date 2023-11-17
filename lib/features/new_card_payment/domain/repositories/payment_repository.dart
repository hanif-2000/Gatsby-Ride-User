import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/add_card_response_modal.dart';
import '../../data/models/card_list_response_modal.dart';

abstract class PaymentRepository {
  Future<Either<Failure, CardListResponseModal>> getCardDetails();
  Future<Either<Failure, AddCardResponseModal>> addCardDetails(
      FormData formData);
}
