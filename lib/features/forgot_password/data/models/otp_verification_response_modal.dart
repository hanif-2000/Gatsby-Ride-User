import 'package:equatable/equatable.dart';

class OtpVerificationResponseModal extends Equatable {
  final int success;
  final String? message;

  const OtpVerificationResponseModal({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];

  factory OtpVerificationResponseModal.fromJson(Map<String, dynamic> json) =>
      OtpVerificationResponseModal(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success};
}
