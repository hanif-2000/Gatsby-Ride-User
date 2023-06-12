import 'package:equatable/equatable.dart';

class CreateOrderResponseModel extends Equatable {
  final int success;
  final String? message;
  final int orderId;

  const CreateOrderResponseModel({
    required this.success,
    this.message,
    required this.orderId,
  });

  @override
  List<Object?> get props => [success, message];

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateOrderResponseModel(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
        orderId: json['id'],
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success, 'id': orderId};
}
