import 'package:equatable/equatable.dart';

import '../../data/models/edit_profile_response_model.dart';
import '../../data/models/profile_response_model.dart';

abstract class CreateProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateProfileInitial extends CreateProfileState {}

class CreateProfileLoading extends CreateProfileState {}

class CreateProfileLoaded extends CreateProfileState {
  final User data;
  CreateProfileLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class CreateProfileUpdateSuccess extends CreateProfileState {
  final int success;
  CreateProfileUpdateSuccess({required this.success});

  @override
  List<Object?> get props => [success];
}

class CreateProfileSuccess extends CreateProfileState {
  final EditProfileResponseModel data;
  CreateProfileSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class CreateProfileFailure extends CreateProfileState {
  final String failure;

  CreateProfileFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
