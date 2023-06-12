import 'package:equatable/equatable.dart';

class AboutUsResponseModel extends Equatable {
  final AboutUsDataModel? data;
  final num? success;

  const AboutUsResponseModel({
    this.data,
    this.success,
  });

  @override
  List<Object?> get props => [data, success];

  factory AboutUsResponseModel.fromJson(Map<String, dynamic> json) =>
      AboutUsResponseModel(
        data: json['message'] == null
            ? null
            : AboutUsDataModel.fromJson(json['message']),
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() => {
        'data': data == null ? null : data!.toJson(),
        'success': success ?? '',
      };
}

class AboutUsDataModel extends Equatable {
  final String? text;

  const AboutUsDataModel({
    required this.text,
  });

  @override
  List<Object?> get props => [text];

  factory AboutUsDataModel.fromJson(Map<String, dynamic> json) =>
      AboutUsDataModel(
        text: json['text'],
      );
  Map<String, dynamic> toJson() => {
        'text': text,
      };
}
