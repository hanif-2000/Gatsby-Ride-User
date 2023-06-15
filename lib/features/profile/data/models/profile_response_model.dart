// To parse this JSON data, do
//
//     final profileResponseModel = profileResponseModelFromJson(jsonString);

import 'dart:convert';

ProfileResponseModel profileResponseModelFromJson(String str) =>
    ProfileResponseModel.fromJson(json.decode(str));

String profileResponseModelToJson(ProfileResponseModel data) =>
    json.encode(data.toJson());

class ProfileResponseModel {
  ProfileResponseModel({
    required this.success,
    required this.user,
  });

  int success;
  User user;

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfileResponseModel(
        success: json["success"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.photo,
    this.firstName,
    this.lastName,
    this.country,
  });

  int id;
  String name;
  String email;
  String phone;
  int status;
  dynamic photo;
  String? firstName;
  String? lastName;
  String? country;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        status: json["status"],
        photo: json["image"],
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        country: json["country"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "status": status,
        "image": photo,
        "firstName": photo,
        "lastName": photo,
        "country": photo,
      };
}
