// To parse this JSON data, do
//
//     final newCustomerResponseDataModel = newCustomerResponseDataModelFromJson(jsonString);

import 'dart:convert';

NewCustomerResponseDataModel newCustomerResponseDataModelFromJson(String str) =>
    NewCustomerResponseDataModel.fromJson(json.decode(str));

String newCustomerResponseDataModelToJson(NewCustomerResponseDataModel data) =>
    json.encode(data.toJson());

class NewCustomerResponseDataModel {
  int success;
  Data data;

  NewCustomerResponseDataModel({
    required this.success,
    required this.data,
  });

  factory NewCustomerResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NewCustomerResponseDataModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  String driverDetail;
  CustomerDetail customerDetail;

  Data({
    required this.driverDetail,
    required this.customerDetail,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        driverDetail: json["driver_detail"],
        customerDetail: CustomerDetail.fromJson(json["customer_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "driver_detail": driverDetail,
        "customer_detail": customerDetail.toJson(),
      };
}

class CustomerDetail {
  int id;
  String name;
  String firstName;
  String lastName;
  String email;
  String phone;
  dynamic otp;
  String country;
  String loginType;
  dynamic socialId;
  dynamic firebaseUid;
  String fcmToken;
  String deviceType;
  String chatToken;
  int verificationStatus;
  int status;
  int firstOrder;
  String image;
  dynamic latitude;
  dynamic longitude;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int pendingAmount;

  CustomerDetail({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.otp,
    required this.country,
    required this.loginType,
    required this.socialId,
    required this.firebaseUid,
    required this.fcmToken,
    required this.deviceType,
    required this.chatToken,
    required this.verificationStatus,
    required this.status,
    required this.firstOrder,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.pendingAmount,
  });

  factory CustomerDetail.fromJson(Map<String, dynamic> json) => CustomerDetail(
        id: json["id"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        otp: json["otp"],
        country: json["country"],
        loginType: json["login_type"],
        socialId: json["social_id"],
        firebaseUid: json["firebase_uid"],
        fcmToken: json["fcm_token"],
        deviceType: json["device_type"],
        chatToken: json["chat_token"],
        verificationStatus: json["verification_status"],
        status: json["status"],
        firstOrder: json["first_order"],
        image: json["image"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pendingAmount: json["pending_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "otp": otp,
        "country": country,
        "login_type": loginType,
        "social_id": socialId,
        "firebase_uid": firebaseUid,
        "fcm_token": fcmToken,
        "device_type": deviceType,
        "chat_token": chatToken,
        "verification_status": verificationStatus,
        "status": status,
        "first_order": firstOrder,
        "image": image,
        "Latitude": latitude,
        "Longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "pending_amount": pendingAmount,
      };
}
