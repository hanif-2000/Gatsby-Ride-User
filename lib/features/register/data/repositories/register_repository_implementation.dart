import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/register/data/datasources/register_data_source.dart';
import 'package:GetsbyRideshare/features/register/data/models/register_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/register_repository.dart';

class RegisterRepositoryImplementation implements RegisterRepository {
  final RegisterDataSource dataSource;

  RegisterRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, RegisterResponseModel>> doRegister(
      Map<String, dynamic> requestData) async {
    try {
      final data = await dataSource.doRegister(requestData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure register repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
