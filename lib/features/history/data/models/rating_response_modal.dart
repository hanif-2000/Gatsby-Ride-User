import 'dart:convert';

GetRatingResponseModal getRatingResponseModalFromJson(String str) =>
    GetRatingResponseModal.fromJson(json.decode(str));

String getRatingResponseModalToJson(GetRatingResponseModal data) =>
    json.encode(data.toJson());

class GetRatingResponseModal {
  int success;
  String message;
  int rating;
  List<ListElement> list;
  int ratingCount;

  GetRatingResponseModal({
    required this.success,
    required this.message,
    required this.rating,
    required this.list,
    required this.ratingCount,
  });

  factory GetRatingResponseModal.fromJson(Map<String, dynamic> json) =>
      GetRatingResponseModal(
        success: json["success"],
        message: json["message"],
        rating: json["rating"],
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
        ratingCount: json["ratingCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "rating": rating,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "ratingCount": ratingCount,
      };
}

class ListElement {
  int id;
  String name;
  String image;
  String rating;
  String review;
  DateTime createdAt;

  ListElement({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"] ?? "",
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        rating: json["rating"] ?? '',
        review: json["review"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "rating": rating,
        "review": review,
        "created_at": createdAt.toIso8601String(),
      };
}
