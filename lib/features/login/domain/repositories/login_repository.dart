import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/login_response_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponseModel?>> doLogin(
      String email, String password, String loginType, String deviceType);

  Future<Either<Failure, LoginResponseModel?>> doLoginSocial(
    String email,
    String firstName,
    String lastName,
    String loginType,
    String deviceType,
    String socialId,
  );
}
