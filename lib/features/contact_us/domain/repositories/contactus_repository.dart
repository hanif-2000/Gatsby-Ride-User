import 'package:appkey_taxiapp_user/core/error/failure.dart';
import 'package:appkey_taxiapp_user/features/contact_us/data/models/contactus_response_modal.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class ContactUsRepository {
  Future<Either<Failure, ContactUsResponseModel?>> doContactUs(
      FormData formData);
}
