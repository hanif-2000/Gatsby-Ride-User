import 'package:equatable/equatable.dart';

class DriverDetail extends Equatable {
  final String name, phone, model, plat;

  const DriverDetail({
    required this.name,
    required this.phone,
    required this.model,
    required this.plat,
  });

  toJson() {}

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [name, phone, model, plat];
}
