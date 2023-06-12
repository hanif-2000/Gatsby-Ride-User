import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/about_us/data/datasources/aboutus_data_source.dart';
import 'package:appkey_taxiapp_user/features/about_us/data/models/aboutus_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/aboutus_repository.dart';

class AboutUsRepositoryImplementation implements AboutUsRepository {
  final AboutUsDataSource dataSource;

  AboutUsRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, AboutUsDataModel?>> getAboutUs() async {
    try {
      final data = await dataSource.getAboutUs();
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure login repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
