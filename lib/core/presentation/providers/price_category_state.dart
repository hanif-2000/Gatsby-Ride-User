import 'package:equatable/equatable.dart';

import '../../domain/entities/price_category.dart';
import '../../error/failure.dart';

abstract class PriceCategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PriceCategoryEmpty extends PriceCategoryState {}

class PriceCategoryLoading extends PriceCategoryState {}

class PriceCategoryLoaded extends PriceCategoryState {
  // final StoreList data;
  final List<PriceCategory> data;

  PriceCategoryLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class PriceCategoryFailure extends PriceCategoryState {
  final Failure failure;

  PriceCategoryFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
