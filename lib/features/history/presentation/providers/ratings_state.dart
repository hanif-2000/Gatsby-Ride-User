import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/rating_response_modal.dart';

abstract class GetRatingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRatingsInitial extends GetRatingState {}

class GetRatingLoading extends GetRatingState {}

class GetRatingLoaded extends GetRatingState {
  final GetRatingResponseModal data;

  GetRatingLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetRatingFailure extends GetRatingState {
  final Failure failure;

  GetRatingFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
