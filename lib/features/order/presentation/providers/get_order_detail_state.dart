import 'package:appkey_taxiapp_user/features/order/data/models/create_order_response_model.dart';
import 'package:appkey_taxiapp_user/features/order/data/models/driver_location_response_model.dart';
import 'package:appkey_taxiapp_user/features/order/data/models/get_status_response.dart';
import 'package:appkey_taxiapp_user/features/order/domain/entities/order_detail.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/status_oder_response_model.dart';

abstract class GetOrderDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetOrderDetailInitial extends GetOrderDetailState {}

class GetOrderDetailLoading extends GetOrderDetailState {}

class GetOrderDetailLoaded extends GetOrderDetailState {
  final OrderDetail data;

  GetOrderDetailLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetOrderDetailFailure extends GetOrderDetailState {
  final Failure failure;

  GetOrderDetailFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
