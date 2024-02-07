class GetChatModel {
  String? response;
  String? message;
  String? type;
  List<Data>? data;

  GetChatModel({this.response, this.message, this.type, this.data});

  GetChatModel.fromJson(Map<String, dynamic> json) {
    response = json['Response'];
    message = json['message'];
    type = json['type'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Response'] = this.response;
    data['message'] = this.message;
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? senderType;
  String? recieverType;
  String? sourceUserId;
  String? targetUserId;
  String? message;
  String? createdOn;
  String? senderName;
 dynamic? senderId;
  String? senderProfilePicture;
  String? receiverName;
  var receiverId;
  String? receiverProfilePicture;

  Data(
      {this.senderType,
        this.recieverType,
        this.sourceUserId,
        this.targetUserId,
        this.message,
        this.createdOn,
        this.senderName,
        this.senderId,
        this.senderProfilePicture,
        this.receiverName,
        this.receiverId,
        this.receiverProfilePicture});

  Data.fromJson(Map<String, dynamic> json) {
    senderType = json['senderType'];
    recieverType = json['recieverType'];
    sourceUserId = json['source_user_id'];
    targetUserId = json['target_user_id'];
    message = json['message'];
    createdOn = json['created_on'];
    senderName = json['senderName'];
    senderId = json['sender_id'];
    senderProfilePicture = json['sender_profile_picture'];
    receiverName = json['receiverName'];
    receiverId = json['receiver_id'];
    receiverProfilePicture = json['receiver_profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderType'] = this.senderType;
    data['recieverType'] = this.recieverType;
    data['source_user_id'] = this.sourceUserId;
    data['target_user_id'] = this.targetUserId;
    data['message'] = this.message;
    data['created_on'] = this.createdOn;
    data['senderName'] = this.senderName;
    data['sender_id'] = this.senderId;
    data['sender_profile_picture'] = this.senderProfilePicture;
    data['receiverName'] = this.receiverName;
    data['receiver_id'] = this.receiverId;
    data['receiver_profile_picture'] = this.receiverProfilePicture;
    return data;
  }
}