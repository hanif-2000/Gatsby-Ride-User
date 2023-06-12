import 'package:equatable/equatable.dart';

class ForgotPasswordResponseModel extends Equatable {
  final int success;
  final String? message;

  const ForgotPasswordResponseModel({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponseModel(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success};
}
