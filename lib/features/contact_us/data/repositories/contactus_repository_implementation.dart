import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/contact_us/data/datasources/contactus_data_source.dart';
import 'package:GetsbyRideshare/features/contact_us/data/models/contactus_response_modal.dart';
import 'package:GetsbyRideshare/features/contact_us/domain/repositories/contactus_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

class ContactUsRepositoryImplementation implements ContactUsRepository {
  final ContactUsDataSource dataSource;

  ContactUsRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, ContactUsResponseModel>> doContactUs(
      FormData formData) async {
    try {
      final data = await dataSource.doContactUs(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure ContactUs repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
