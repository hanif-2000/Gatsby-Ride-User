class NotificationEntity {
  String? title;
  String? body;
  String? type;
  String? courseId;

  NotificationEntity({this.title, this.body, this.type, this.courseId});

  NotificationEntity.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    type = json['type'];
    courseId = json['courseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['body'] = body;
    data['title'] = title;
    data['courseId'] = courseId;
    return data;
  }
}
