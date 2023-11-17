import 'package:GetsbyRideshare/features/order/data/models/get_status_response.dart';
import 'package:GetsbyRideshare/features/order/data/models/order_receipt_response_modal.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/create_order_response_model.dart';
import '../../data/models/driver_location_response_model.dart';
import '../../data/models/status_oder_response_model.dart';
import '../../data/models/submit_rating_response_modal.dart';
import '../entities/driver_detail.dart';
import '../entities/order_detail.dart';

abstract class OrderRepository {
  Future<Either<Failure, CreateOrderResponseModel>> createOrder(
      FormData formData);
  Future<Either<Failure, UpdateStatusOrderResponseModel>> updateStatusOrder(
      FormData formData);
  Future<Either<Failure, GetStatusResponseModel>> getStatusOrder();
  Future<Either<Failure, OrderDetail>> getDetailOrder();
  Future<Either<Failure, DriverDetail>> getDriverDetail();
  Future<Either<Failure, DriverLocationResponseModel>> getDriverLocation();
  Future<Either<Failure, SubmitRatingsResponseModel>> submitRating(
      FormData formData);
  Future<Either<Failure, OrderReceiptResponseModel>> orderReceipt(
      FormData formData);
}
