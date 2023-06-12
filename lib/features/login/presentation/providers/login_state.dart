import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/login_response_model.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginDataModel? data;
  LoginSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class LoginFailure extends LoginState {
  final String failure;

  LoginFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
