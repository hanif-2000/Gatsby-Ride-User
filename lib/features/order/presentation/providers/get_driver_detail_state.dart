import 'package:GetsbyRideshare/features/order/domain/entities/driver_detail.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';

abstract class GetDriverDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDriverDetailInitial extends GetDriverDetailState {}

class GetDriverDetailLoading extends GetDriverDetailState {}

class GetDriverDetailLoaded extends GetDriverDetailState {
  final DriverDetail data;

  GetDriverDetailLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetDriverDetailFailure extends GetDriverDetailState {
  final Failure failure;

  GetDriverDetailFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
