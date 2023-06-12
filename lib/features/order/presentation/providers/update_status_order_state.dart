import 'package:appkey_taxiapp_user/features/order/data/models/create_order_response_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/status_oder_response_model.dart';

abstract class UpdateStatusOrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateStatusOrderInitial extends UpdateStatusOrderState {}

class UpdateStatusOrderLoading extends UpdateStatusOrderState {}

class UpdateStatusOrderLoaded extends UpdateStatusOrderState {
  final UpdateStatusOrderResponseModel data;

  UpdateStatusOrderLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateStatusOrderFailure extends UpdateStatusOrderState {
  final Failure failure;

  UpdateStatusOrderFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
