import 'package:equatable/equatable.dart';

class LoginResponseModel extends Equatable {
  final LoginDataModel? data;
  final num? success;
  final String? token;
  final String? message;

  const LoginResponseModel({
    this.data,
    this.success,
    this.token,
    this.message,
  });

  @override
  List<Object?> get props => [data, success, token, message];

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
          data: json['user'] == null
              ? null
              : LoginDataModel.fromJson(json['user']),
          token: json['token'] ?? '',
          success: json['success'] ?? 1,
          message: json['message'] ?? '');
  Map<String, dynamic> toJson() => {
        'data': data ?? null,
        // 'data': data == null ? '' : data!.toJson(),

        'token': token ?? '',
        'success': success ?? '',
        'message': message ?? ''
      };
}

class LoginDataModel extends Equatable {
  final num userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String fcmToken;
  final int status;
  final String image;
  final int? chatToken;

  const LoginDataModel(
      {required this.userId,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.fcmToken,
      required this.status,
      required this.chatToken,
      required this.image});

  @override
  List<Object?> get props =>
      [userId, name, email, phoneNumber, fcmToken, status, image, chatToken];

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
      userId: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? '',
      fcmToken: json['fcm_token'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? 0,
      chatToken: json['chat_token'] ?? 0);

  Map<String, dynamic> toJson() => {
        'id': userId,
        'nama_user': name,
        'email': email,
        'phone': phoneNumber,
        'fcm_token': fcmToken,
        'image': image,
        'status': status,
        'chat_token': chatToken,
      };
}
