import 'package:equatable/equatable.dart';

class AddCardResponseModal extends Equatable {
  final int success;
  final String? message;

  const AddCardResponseModal({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];

  factory AddCardResponseModal.fromJson(Map<String, dynamic> json) =>
      AddCardResponseModal(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success};
}
