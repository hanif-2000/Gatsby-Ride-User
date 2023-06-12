import 'package:equatable/equatable.dart';

import '../../data/models/history_response_model.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryOrder> data;
  HistoryLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class HistoryFailure extends HistoryState {
  final String failure;

  HistoryFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
