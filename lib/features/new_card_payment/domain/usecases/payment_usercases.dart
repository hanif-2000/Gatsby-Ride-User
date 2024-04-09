import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/add_card_response_modal.dart';
import '../../data/models/card_list_response_modal.dart';
import '../repositories/payment_repository.dart';

abstract class PaymentUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, CardListResponseModal>> call();
  Future<Either<Failure, AddCardResponseModal>> execute(FormData formData);
  Future<Either<Failure, AddCardResponseModal>> delete(FormData formData);
}

class PaymentCard implements PaymentUseCase<String> {
  final PaymentRepository repository;

  PaymentCard({required this.repository});

  @override
  Future<Either<Failure, CardListResponseModal>> call() async {
    final result = await repository.getCardDetails();
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }

  @override
  Future<Either<Failure, AddCardResponseModal>> execute(
      FormData formData) async {
    final result = await repository.addCardDetails(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }

  @override
  Future<Either<Failure, AddCardResponseModal>> delete(FormData formData) async{
    final result = await repository.deleteCard(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
