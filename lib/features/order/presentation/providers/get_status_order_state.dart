import 'package:appkey_taxiapp_user/features/order/data/models/create_order_response_model.dart';
import 'package:appkey_taxiapp_user/features/order/data/models/get_status_response.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/status_oder_response_model.dart';

abstract class GetStatusOrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetStatusOrderInitial extends GetStatusOrderState {}

class GetStatusOrderLoading extends GetStatusOrderState {}

class GetStatusOrderLoaded extends GetStatusOrderState {
  final GetStatusResponseModel data;

  GetStatusOrderLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetStatusOrderFailure extends GetStatusOrderState {
  final Failure failure;

  GetStatusOrderFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
