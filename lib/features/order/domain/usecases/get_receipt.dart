import 'package:appkey_taxiapp_user/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/order_receipt_response_modal.dart';

abstract class GetOrderReceiptUseCase<Type> {
  Future<Either<Failure, OrderReceiptResponseModel>> execute(FormData formData);
}

class GetOrderReceipt implements GetOrderReceiptUseCase<String> {
  final OrderRepository repository;

  GetOrderReceipt({required this.repository});

  @override
  Future<Either<Failure, OrderReceiptResponseModel>> execute(
      FormData formData) async {
    final result = await repository.orderReceipt(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
