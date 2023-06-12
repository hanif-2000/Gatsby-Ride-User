import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/aboutus_response_model.dart';

abstract class AboutUsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AboutUsInitial extends AboutUsState {}

class AboutUsLoading extends AboutUsState {}

class AboutUsLoaded extends AboutUsState {
  final AboutUsDataModel? data;
  AboutUsLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class AboutUsFailure extends AboutUsState {
  final String failure;

  AboutUsFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
