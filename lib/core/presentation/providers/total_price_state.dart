import 'package:equatable/equatable.dart';

import '../../domain/entities/total_price.dart';
import '../../error/failure.dart';

abstract class TotalPriceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TotalPriceInitial extends TotalPriceState {}

class TotalPriceLoading extends TotalPriceState {}

class TotalPriceLoaded extends TotalPriceState {
  final TotalPrice data;

  TotalPriceLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class TotalPriceFailure extends TotalPriceState {
  final Failure failure;

  TotalPriceFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
