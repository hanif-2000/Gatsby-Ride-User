import 'package:equatable/equatable.dart';

class RegisterResponseModel extends Equatable {
  final int success;
  final String? message;
  final String? token;
  final dynamic userId;
  final dynamic chatToken;

  const RegisterResponseModel(
      {required this.success,
      this.message,
      this.token,
      this.userId,
      this.chatToken});

  @override
  List<Object?> get props => [success, message];

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
          message: json['message'] ?? '',
          success: json['success'] ?? 1,
          token: json['token'] ?? '',
          userId: json['id'] ?? '',
          chatToken: json['chat_token'] ?? 0);
  Map<String, dynamic> toJson() => {
        'message': message ?? '',
        'success': success,
        'token': token ?? '',
        "id": userId ?? '',
        "chatToken": chatToken ?? '',
      };
}
