import 'package:equatable/equatable.dart';

import '../../../../core/utility/helper.dart';

class SubmitRatingsResponseModel extends Equatable {
  final String message;
  final int success;

  const SubmitRatingsResponseModel(
      {required this.message, required this.success});

  @override
  List<Object?> get props => [message, success];

  factory SubmitRatingsResponseModel.fromJson(Map<String, dynamic> json) {
    late String _message;
    late int _success;

    try {
      final String? message = json['message'] ?? '';
      final int? success = json['success'] ?? -1;

      _message = message!;
      _success = success!;
    } catch (e) {
      logMe(e);
      _message = '';
      _success = -1;
    }
    return SubmitRatingsResponseModel(
      message: _message,
      success: _success,
    );
  }
}
