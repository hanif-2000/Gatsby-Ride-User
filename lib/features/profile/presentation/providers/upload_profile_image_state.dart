import 'package:equatable/equatable.dart';

import '../../data/models/edit_profile_response_model.dart';
import '../../data/models/profile_response_model.dart';

abstract class UploadProfileImageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadProfileImageInitial extends UploadProfileImageState {}

class UploadProfileImageLoading extends UploadProfileImageState {}

class UploadProfileImageLoaded extends UploadProfileImageState {
  final User data;
  UploadProfileImageLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class UploadProfileImageUpdateSuccess extends UploadProfileImageState {
  final int success;
  UploadProfileImageUpdateSuccess({required this.success});

  @override
  List<Object?> get props => [success];
}

class UploadProfileImageSuccess extends UploadProfileImageState {
  final EditProfileResponseModel data;
  UploadProfileImageSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class UploadProfileImageFailure extends UploadProfileImageState {
  final String failure;

  UploadProfileImageFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
