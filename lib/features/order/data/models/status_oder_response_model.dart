import 'package:equatable/equatable.dart';

class UpdateStatusOrderResponseModel extends Equatable {
  final int success;
  final String? message;

  const UpdateStatusOrderResponseModel({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];

  factory UpdateStatusOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateStatusOrderResponseModel(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success};
}
