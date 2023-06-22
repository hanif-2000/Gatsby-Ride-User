import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/order_receipt_response_modal.dart';

abstract class GetReceiptState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetReceiptInitial extends GetReceiptState {}

class GetReceiptLoading extends GetReceiptState {}

class GetReceiptLoaded extends GetReceiptState {
  final OrderReceiptResponseModel data;

  GetReceiptLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetReceiptFailure extends GetReceiptState {
  final Failure failure;

  GetReceiptFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
