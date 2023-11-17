import 'package:GetsbyRideshare/features/order/domain/entities/driver_detail.dart';
import 'package:equatable/equatable.dart';

class DriverDetailResponse extends Equatable {
  final int success;
  final DriverDetail data;

  const DriverDetailResponse({
    required this.success,
    required this.data,
  });

  @override
  List<Object?> get props => [
        success,
        data,
      ];

  Map<String, dynamic> toJson() => {};
}
