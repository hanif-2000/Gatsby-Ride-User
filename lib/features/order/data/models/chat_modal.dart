class ChatDataModel {
  String? message;
  int? senderId;
  int? receiverId;
  DateTime? dateTime;

  ChatDataModel(
    this.message,
    this.senderId,
    this.receiverId,
    this.dateTime,
  );
}

class ChatModel {
  String? id;
  String? roomId;
  String? sourceUserId;
  String? targetUserId;
  String? senderType;
  String? recieverType;
  String? message;
  String? status;
  String? messageType;
  DateTime? modifiedOn;
  DateTime? createdOn;

  ChatModel({
    this.id,
    this.roomId,
    this.sourceUserId,
    this.targetUserId,
    this.senderType,
    this.recieverType,
    this.message,
    this.status,
    this.messageType,
    this.modifiedOn,
    this.createdOn,
  });

  factory ChatModel.fromMap(Map<String, dynamic> json) => ChatModel(
        id: json["id"]?.toString(),
        roomId: json["roomID"],
        sourceUserId: json["source_user_id"]?.toString(),
        targetUserId: json["target_user_id"]?.toString(),
        senderType: json["senderType"],
        recieverType: json["recieverType"],
        message: json["message"] ?? json["msg"],
        status: json["status"],
        messageType: json["MessageType"],
        modifiedOn: json["modified_on"] != null ? DateTime.tryParse(json["modified_on"]) ?? DateTime.now() : DateTime.now(),
        createdOn: json["created_on"] != null ? DateTime.tryParse(json["created_on"]) ?? DateTime.now() : DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "roomID": roomId,
        "source_user_id": sourceUserId,
        "target_user_id": targetUserId,
        "senderType": senderType,
        "recieverType": recieverType,
        "message": message,
        "status": status,
        "MessageType": messageType,
        "modified_on": modifiedOn!.toIso8601String(),
        "created_on": createdOn!.toIso8601String(),
      };
}
