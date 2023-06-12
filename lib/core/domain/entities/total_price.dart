import 'package:equatable/equatable.dart';

class TotalPrice extends Equatable {
  final String data;

  const TotalPrice({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}
