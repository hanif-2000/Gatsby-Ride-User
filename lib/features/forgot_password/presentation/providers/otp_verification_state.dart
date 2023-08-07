import 'package:GetsbyRideshare/features/forgot_password/data/models/otp_verification_response_modal.dart';
import 'package:equatable/equatable.dart';

abstract class OtpVerificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpVerificationInitial extends OtpVerificationState {}

class OtpVerificationLoading extends OtpVerificationState {}

class OtpVerificationSuccess extends OtpVerificationState {
  final OtpVerificationResponseModal data;
  OtpVerificationSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class OtpVerificationFailure extends OtpVerificationState {
  final String failure;

  OtpVerificationFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
