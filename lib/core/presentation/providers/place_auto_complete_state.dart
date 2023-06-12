import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/google_places.dart';

abstract class PlaceAutoCompleteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaceInitial extends PlaceAutoCompleteState {}

class PlaceLoading extends PlaceAutoCompleteState {}

class PlaceAutoLoaded extends PlaceAutoCompleteState {
  final List<GooglePlaceSearch> data;

  PlaceAutoLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class PlaceFailure extends PlaceAutoCompleteState {
  final Failure failure;

  PlaceFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
