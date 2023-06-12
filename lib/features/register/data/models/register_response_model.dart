import 'package:equatable/equatable.dart';

class RegisterResponseModel extends Equatable {
  final int success;
  final String? message;
  final String? token;

  const RegisterResponseModel({
    required this.success,
    this.message,
    this.token,
  });

  @override
  List<Object?> get props => [success, message];

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
        token: json['token'] ?? '',
      );
  Map<String, dynamic> toJson() => {
        'message': message ?? '',
        'success': success,
        'token': token ?? '',
      };
}
