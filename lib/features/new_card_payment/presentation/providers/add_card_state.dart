import 'package:GetsbyRideshare/features/new_card_payment/data/models/add_card_response_modal.dart';
import 'package:equatable/equatable.dart';

abstract class AddCardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddCardInitial extends AddCardState {}

class AddCardLoading extends AddCardState {}
class DeleteCardLoading extends AddCardState {}

class AddCardSuccess extends AddCardState {
  final AddCardResponseModal data;
  AddCardSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}
class DeleteCardSuccess extends AddCardState {
  final AddCardResponseModal data;
  DeleteCardSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class AddCardFailure extends AddCardState {
  final String failure;

  AddCardFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
class DeleteCardFailure extends AddCardState {
  final String failure;

  DeleteCardFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
