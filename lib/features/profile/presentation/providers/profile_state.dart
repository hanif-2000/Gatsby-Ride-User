import 'package:equatable/equatable.dart';

import '../../data/models/edit_profile_response_model.dart';
import '../../data/models/profile_response_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User data;
  ProfileLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class ProfileUpdateSuccess extends ProfileState {
  final int success;
  ProfileUpdateSuccess({required this.success});

  @override
  List<Object?> get props => [success];
}

class ChangePasswordSuccess extends ProfileState {
  final EditProfileResponseModel data;
  ChangePasswordSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class ProfileFailure extends ProfileState {
  final String failure;

  ProfileFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
