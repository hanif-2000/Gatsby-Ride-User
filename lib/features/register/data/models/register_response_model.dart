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

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final innerData = json['data'] as Map<String, dynamic>?;
    final user = innerData?['user'] as Map<String, dynamic>?;
    return RegisterResponseModel(
      message: json['message'] ?? '',
      success: json['success'] ?? 1,
      token: innerData?['token'] ?? json['token'] ?? '',
      userId: user?['id'] ?? json['id'] ?? '',
      chatToken: int.tryParse((user?['chat_token'] ?? json['chat_token'] ?? 0).toString()) ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'message': message ?? '',
        'success': success,
        'token': token ?? '',
        "id": userId ?? '',
        "chatToken": chatToken ?? '',
      };
}
