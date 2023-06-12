import 'package:appkey_taxiapp_user/features/order/data/models/create_order_response_model.dart';
import 'package:equatable/equatable.dart';

import '../../error/failure.dart';

abstract class CreateOrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderLoading extends CreateOrderState {}

class CreateOrderLoaded extends CreateOrderState {
  final CreateOrderResponseModel data;

  CreateOrderLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class CreateOrderFailure extends CreateOrderState {
  final Failure failure;

  CreateOrderFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
