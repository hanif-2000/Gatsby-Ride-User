import 'package:GetsbyRideshare/features/order/data/models/driver_location_response_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';

abstract class GetDriverLocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDriverLocationInitial extends GetDriverLocationState {}

class GetDriverLocationLoading extends GetDriverLocationState {}

class GetDriverLocationLoaded extends GetDriverLocationState {
  final DriverLocationResponseModel data;

  GetDriverLocationLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetDriverLocationFailure extends GetDriverLocationState {
  final Failure failure;

  GetDriverLocationFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
