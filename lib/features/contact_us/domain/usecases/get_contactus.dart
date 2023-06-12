import 'package:appkey_taxiapp_user/features/contact_us/data/models/contactus_response_modal.dart';
import 'package:appkey_taxiapp_user/features/contact_us/domain/repositories/contactus_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

abstract class ContactusUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, ContactUsResponseModel>> call(FormData formData);
}

class DoContactUs implements ContactusUseCase<String> {
  final ContactUsRepository repository;

  DoContactUs({required this.repository});

  @override
  Future<Either<Failure, ContactUsResponseModel>> call(
      FormData formData) async {
    final result = await repository.doContactUs(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r!);
    });
  }
}
