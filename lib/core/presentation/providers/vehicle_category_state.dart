import 'package:equatable/equatable.dart';

import '../../domain/entities/vehicles_category.dart';
import '../../error/failure.dart';

abstract class VehiclesCategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehiclesCategoryEmpty extends VehiclesCategoryState {}

class VehiclesCategoryLoading extends VehiclesCategoryState {}

class VehiclesCategoryLoaded extends VehiclesCategoryState {
  // final StoreList data;
  final List<VehiclesCategory> data;

  VehiclesCategoryLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class VehiclesCategoryFailure extends VehiclesCategoryState {
  final Failure failure;

  VehiclesCategoryFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
