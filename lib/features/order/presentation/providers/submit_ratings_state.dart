import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/submit_rating_response_modal.dart';

abstract class SubmitRatingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitRatingsInitial extends SubmitRatingsState {}

class SubmitRatingsLoading extends SubmitRatingsState {}

class SubmitRatingsLoaded extends SubmitRatingsState {
  final SubmitRatingsResponseModel data;

  SubmitRatingsLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class SubmitRatingsFailure extends SubmitRatingsState {
  final Failure failure;

  SubmitRatingsFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
