import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/login_response_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponseModel?>> doLogin(
      String email, String password);
}
