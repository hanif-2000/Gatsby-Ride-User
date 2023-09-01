import 'dart:convert';

import 'package:equatable/equatable.dart';

OrderPaymentResponseModal orderPaymentResponseModalFromJson(String str) =>
    OrderPaymentResponseModal.fromJson(json.decode(str));

String orderPaymentResponseModalToJson(OrderPaymentResponseModal data) =>
    json.encode(data.toJson());

class OrderPaymentResponseModal extends Equatable {
  int success;
  String message;

  OrderPaymentResponseModal({
    required this.success,
    required this.message,
  });

  factory OrderPaymentResponseModal.fromJson(Map<String, dynamic> json) =>
      OrderPaymentResponseModal(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
