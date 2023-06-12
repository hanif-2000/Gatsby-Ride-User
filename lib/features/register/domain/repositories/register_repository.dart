import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/register_response_model.dart';

abstract class RegisterRepository {
  Future<Either<Failure, RegisterResponseModel>> doRegister(FormData formData);
}
