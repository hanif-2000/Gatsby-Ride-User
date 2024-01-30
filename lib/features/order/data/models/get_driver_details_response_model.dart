// To parse this JSON data, do
//
//     final getDriverDetailsResponseModel = getDriverDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

GetDriverDetailsResponseModel getDriverDetailsResponseModelFromJson(
        String str) =>
    GetDriverDetailsResponseModel.fromJson(json.decode(str));

String getDriverDetailsResponseModelToJson(
        GetDriverDetailsResponseModel data) =>
    json.encode(data.toJson());

class GetDriverDetailsResponseModel {
  int success;
  Data data;

  GetDriverDetailsResponseModel({
    required this.success,
    required this.data,
  });

  factory GetDriverDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetDriverDetailsResponseModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  DriverDetail driverDetail;
  Rating rating;

  Data({
    required this.driverDetail,
    required this.rating,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        driverDetail: DriverDetail.fromJson(json["driver_detail"]),
        rating: Rating.fromJson(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
        "driver_detail": driverDetail.toJson(),
        "rating": rating.toJson(),
      };
}

class DriverDetail {
  int id;
  String name;
  String firstName;
  String lastName;
  String email;
  String phone;
  dynamic otp;
  String city;
  String state;
  String country;
  String address;
  String postalCode;
  DateTime dob;
  String idNumber;
  dynamic profilePhoto;
  String drivingLicence;
  String drivingLicenceBack;
  dynamic idProof;
  int status;
  String orderStatus;
  int profileStatus;
  int verificationStatus;
  int bankStatus;
  int vehicleCategoryId;
  String plateNumber;
  String vehicleName;
  String carModel;
  String insuranceNumber;
  String firebaseUid;
  String fcmToken;
  String deviceType;
  String chatToken;
  String position;
  String bearing;
  String image;
  int isAvailable;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  DriverDetail({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.otp,
    required this.city,
    required this.state,
    required this.country,
    required this.address,
    required this.postalCode,
    required this.dob,
    required this.idNumber,
    required this.profilePhoto,
    required this.drivingLicence,
    required this.drivingLicenceBack,
    required this.idProof,
    required this.status,
    required this.orderStatus,
    required this.profileStatus,
    required this.verificationStatus,
    required this.bankStatus,
    required this.vehicleCategoryId,
    required this.plateNumber,
    required this.vehicleName,
    required this.carModel,
    required this.insuranceNumber,
    required this.firebaseUid,
    required this.fcmToken,
    required this.deviceType,
    required this.chatToken,
    required this.position,
    required this.bearing,
    required this.image,
    required this.isAvailable,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory DriverDetail.fromJson(Map<String, dynamic> json) => DriverDetail(
        id: json["id"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        otp: json["otp"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        address: json["address"],
        postalCode: json["postal_code"],
        dob: DateTime.parse(json["dob"]),
        idNumber: json["id_number"],
        profilePhoto: json["profile_photo"],
        drivingLicence: json["driving_licence"],
        drivingLicenceBack: json["driving_licence_back"],
        idProof: json["id_proof"],
        status: json["status"],
        orderStatus: json["order_status"],
        profileStatus: json["profile_status"],
        verificationStatus: json["verification_status"],
        bankStatus: json["bank_status"],
        vehicleCategoryId: json["vehicle_category_id"],
        plateNumber: json["plate_number"],
        vehicleName: json["vehicle_name"],
        carModel: json["car_model"],
        insuranceNumber: json["insurance_number"],
        firebaseUid: json["firebase_uid"],
        fcmToken: json["fcm_token"],
        deviceType: json["device_type"],
        chatToken: json["chat_token"],
        position: json["position"],
        bearing: json["bearing"],
        image: json["image"],
        isAvailable: json["is_available"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "otp": otp,
        "city": city,
        "state": state,
        "country": country,
        "address": address,
        "postal_code": postalCode,
        "dob":
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "id_number": idNumber,
        "profile_photo": profilePhoto,
        "driving_licence": drivingLicence,
        "driving_licence_back": drivingLicenceBack,
        "id_proof": idProof,
        "status": status,
        "order_status": orderStatus,
        "profile_status": profileStatus,
        "verification_status": verificationStatus,
        "bank_status": bankStatus,
        "vehicle_category_id": vehicleCategoryId,
        "plate_number": plateNumber,
        "vehicle_name": vehicleName,
        "car_model": carModel,
        "insurance_number": insuranceNumber,
        "firebase_uid": firebaseUid,
        "fcm_token": fcmToken,
        "device_type": deviceType,
        "chat_token": chatToken,
        "position": position,
        "bearing": bearing,
        "image": image,
        "is_available": isAvailable,
        "Latitude": latitude,
        "Longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Rating {
  dynamic rating;

  Rating({
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
      };
}
