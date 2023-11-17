// import 'package:GetsbyRideshare/features/card_payment/data/models/add_card_response_modal.dart';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';

// import '../../../../core/error/failure.dart';
// import '../repositories/profile_repository.dart';

// abstract class AddCardDetailsUseCase<Type> {
//   Future<Either<Failure, AddCardResponseModel>> execute(FormData formData);
// }

// class AddCardDetails implements AddCardDetailsUseCase<String> {
//   final PaymentRepository repository;

//   AddCardDetails({required this.repository});

//   @override
//   Future<Either<Failure, AddCardResponseModel>> execute(
//       FormData formData) async {
//     final result = await repository.addCardDetails(formData);
//     return result.fold((l) => Left(l), (r) {
//       return Right(r);
//     });
//   }
// }
