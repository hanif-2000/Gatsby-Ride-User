import 'package:equatable/equatable.dart';

class DriverDetail extends Equatable {
  final String name, phone, model, plat, id, rating, image;
  // final int id;
  // String? image;
  // int? rating;

  DriverDetail({
    required this.name,
    required this.phone,
    required this.model,
    required this.plat,
    required this.id,
    required this.image,
    required this.rating,
  });

  toJson() {}

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [name, phone, model, plat, id, image, rating];
}
