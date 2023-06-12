import 'package:equatable/equatable.dart';

class ContactUsResponseModel extends Equatable {
  final int success;
  final String? message;

  const ContactUsResponseModel({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];

  factory ContactUsResponseModel.fromJson(Map<String, dynamic> json) =>
      ContactUsResponseModel(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success};
}
