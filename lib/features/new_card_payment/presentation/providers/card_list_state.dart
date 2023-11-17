import 'package:equatable/equatable.dart';

import '../../data/models/card_list_response_modal.dart';

abstract class CardListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CardListInitial extends CardListState {}

class CardListLoading extends CardListState {}

class CardListSuccess extends CardListState {
  final CardListResponseModal data;
  CardListSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class CardListFailure extends CardListState {
  final String failure;

  CardListFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
