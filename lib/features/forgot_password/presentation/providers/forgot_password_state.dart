import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/forgot_password_response_model.dart';

abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponseModel data;
  ForgotPasswordSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String failure;

  ForgotPasswordFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
