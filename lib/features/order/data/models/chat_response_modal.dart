// To parse this JSON data, do
//
//     final chatResponseModal = chatResponseModalFromJson(jsonString);

import 'dart:convert';

ChatResponseModal chatResponseModalFromJson(String str) =>
    ChatResponseModal.fromJson(json.decode(str));

String chatResponseModalToJson(ChatResponseModal data) =>
    json.encode(data.toJson());

class ChatResponseModal {
  String response;
  String message;
  String type;
  List<Datum>? data;

  ChatResponseModal({
    required this.response,
    required this.message,
    required this.type,
    required this.data,
  });

  factory ChatResponseModal.fromJson(Map<String, dynamic> json) =>
      ChatResponseModal(
        response: json["Response"] ?? '',
        message: json["message"] ?? "",
        type: json["type"] ?? '',
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String roomId;
  String sourceUserId;
  String targetUserId;
  String senderType;
  String recieverType;
  String message;
  String status;
  String messageType;
  DateTime modifiedOn;
  DateTime createdOn;

  Datum({
    required this.id,
    required this.roomId,
    required this.sourceUserId,
    required this.targetUserId,
    required this.senderType,
    required this.recieverType,
    required this.message,
    required this.status,
    required this.messageType,
    required this.modifiedOn,
    required this.createdOn,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        roomId: json["roomID"],
        sourceUserId: json["source_user_id"],
        targetUserId: json["target_user_id"],
        senderType: json["senderType"],
        recieverType: json["recieverType"],
        message: json["message"],
        status: json["status"],
        messageType: json["MessageType"],
        modifiedOn: DateTime.parse(json["modified_on"]),
        createdOn: DateTime.parse(json["created_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "roomID": roomId,
        "source_user_id": sourceUserId,
        "target_user_id": targetUserId,
        "senderType": senderType,
        "recieverType": recieverType,
        "message": message,
        "status": status,
        "MessageType": messageType,
        "modified_on": modifiedOn.toIso8601String(),
        "created_on": createdOn.toIso8601String(),
      };
}
