import 'package:equatable/equatable.dart';

class CreateOrderResponseModel extends Equatable {
  final int success;
  final String? message;
  final int id;
  final double total;

  const CreateOrderResponseModel({
    required this.success,
    this.message,
    required this.id,
    required this.total,
  });

  @override
  List<Object?> get props => [success, message];

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return CreateOrderResponseModel(
      message: json['message'] ?? '',
      success: (json['status'] == true) ? 1 : (json['success'] ?? -5),
      id: data?['id'] ?? json['id'] ?? 0,
      total: double.tryParse(data?['total']?.toString() ?? '0') ?? 0.0,
    );
  }
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success, 'id': id, 'total': total};
}
