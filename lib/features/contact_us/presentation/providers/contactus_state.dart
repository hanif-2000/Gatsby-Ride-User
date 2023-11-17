import 'package:GetsbyRideshare/features/contact_us/data/models/contactus_response_modal.dart';
import 'package:equatable/equatable.dart';

abstract class ContactusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactusInitial extends ContactusState {}

class ContactusLoading extends ContactusState {}

class ContactusSuccess extends ContactusState {
  final ContactUsResponseModel data;
  ContactusSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class ContactusFailure extends ContactusState {
  final String failure;

  ContactusFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
