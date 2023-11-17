import 'package:GetsbyRideshare/features/about_us/data/models/aboutus_response_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class AboutUsRepository {
  Future<Either<Failure, AboutUsDataModel?>> getAboutUs();
}
