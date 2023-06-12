import 'package:equatable/equatable.dart';

class EditProfileResponseModel extends Equatable {
  final int success;
  final String? message;
  final String? fileName;

  const EditProfileResponseModel(
      {required this.success, this.message, this.fileName});

  @override
  List<Object?> get props => [success, message, fileName];

  factory EditProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      EditProfileResponseModel(
          message: json['message'] ?? '',
          success: json['success'] ?? 1,
          fileName: json['fileName'] ?? '');
  Map<String, dynamic> toJson() => {
        'message': message ?? '',
        'success': success,
        'fileName': fileName ?? ''
      };
}
