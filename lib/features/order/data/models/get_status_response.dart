import 'package:equatable/equatable.dart';

class GetStatusResponseModel extends Equatable {
  final int status;

  const GetStatusResponseModel({
    required this.status,
  });

  @override
  List<Object?> get props => [status];

  factory GetStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      GetStatusResponseModel(
        status: json['status'] ?? 0,
      );
  Map<String, dynamic> toJson() => {'status': status};
}
