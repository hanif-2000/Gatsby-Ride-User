import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  UserModel({
      this.name, 
      this.socialId, 
      this.email, 
      this.socialType});

  UserModel.fromJson(dynamic json) {
    name = json['name'];
    socialId = json['social_id'];
    email = json['email'];
    socialType = json['socialType'];
  }
  String? name;
  String? socialId;
  String? email;
  String? socialType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['social_id'] = socialId;
    map['email'] = email;
    map['socialType'] = socialType;
    return map;
  }

  @override
  List<Object?> get props => [name,socialId,email,socialType];

}