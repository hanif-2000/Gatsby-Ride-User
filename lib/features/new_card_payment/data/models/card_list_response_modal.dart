// To parse this JSON data, do
//
// final cardListResponseModal = cardListResponseModalFromJson(jsonString);

import 'package:equatable/equatable.dart';

// CardListResponseModal cardListResponseModalFromJson(String str) =>
//     CardListResponseModal.fromJson(json.decode(str));

// String cardListResponseModalToJson(CardListResponseModal data) =>
//     json.encode(data.toJson());

class CardListResponseModal extends Equatable {
  int success;
  String message;
  List<CardData> data;

  CardListResponseModal({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [success, message, data];

  factory CardListResponseModal.fromJson(Map<String, dynamic> json) =>
      CardListResponseModal(
        success: json["success"],
        message: json["message"],
        data:
            List<CardData>.from(json["data"].map((x) => CardData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CardData {
  int id;
  int userId;
  String cardNumber;
  String cardHolderName;
  String cardType;
  String expiryDate;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  CardData({
    required this.id,
    required this.userId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.cardType,
    required this.expiryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CardData.fromJson(Map<String, dynamic> json) => CardData(
        id: json["id"],
        userId: json["user_id"],
        cardNumber: json["card_number"],
        cardHolderName: json["card_holder_name"],
        cardType: json["card_type"],
        expiryDate: json["expiry_date"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "card_number": cardNumber,
        "card_holder_name": cardHolderName,
        "card_type": cardType,
        "expiry_date": expiryDate,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
