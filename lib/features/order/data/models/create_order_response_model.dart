import 'package:equatable/equatable.dart';

class CreateOrderResponseModel extends Equatable {
  final int success;
  final String? message;
  final int id;

  const CreateOrderResponseModel({
    required this.success,
    this.message,
    required this.id,
  });

  @override
  List<Object?> get props => [success, message];

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateOrderResponseModel(
        message: json['message'] ?? '',
        success: json['success'] ?? -5,
        id: json['id'] ?? 0,
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success, 'id': id};
}
