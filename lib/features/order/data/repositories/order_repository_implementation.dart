import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/order/data/models/create_order_response_model.dart';
import 'package:GetsbyRideshare/features/order/data/models/get_status_response.dart';
import 'package:GetsbyRideshare/features/order/data/models/order_receipt_response_modal.dart';
import 'package:GetsbyRideshare/features/order/data/models/status_oder_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/order_detail.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_data_source.dart';
import '../models/driver_location_response_model.dart';
import '../models/submit_rating_response_modal.dart';

class OrderRepositoryImplementation implements OrderRepository {
  final OrderDataSource dataSource;

  OrderRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, CreateOrderResponseModel>> createOrder(
      FormData formData) async {
    try {
      final data = await dataSource.createOrder(formData);
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure Order repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UpdateStatusOrderResponseModel>> updateStatusOrder(
      FormData formData) async {
    try {
      final data = await dataSource.updateStatusOrder(formData);
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure Update status Order repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, GetStatusResponseModel>> getStatusOrder() async {
    try {
      final data = await dataSource.getStatusOrder();
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure get status Order repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, OrderDetail>> getDetailOrder() async {
    try {
      final data = await dataSource.getDetailOrder();
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure getDetailOrder repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  // @override
  // Future<Either<Failure, DriverDetail>> getDriverDetail() async {
  //   try {
  //     final data = await dataSource.getDriverDetail();
  //     return Right(data);
  //   } on DioError catch (e) {
  //     logMe("Failure getDriverDetail repository ${e.toString()}");
  //     return Left(ServerFailure(message: e.message));
  //   }
  // }

  @override
  Future<Either<Failure, DriverLocationResponseModel>>
      getDriverLocation() async {
    try {
      final data = await dataSource.getDriverLocation();
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure getDriverLocation repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

//Submit Ratings
  @override
  Future<Either<Failure, SubmitRatingsResponseModel>> submitRating(
      FormData formData) async {
    try {
      final data = await dataSource.submitRatings(formData);
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure Submit Ratings repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

//Order receipt
  @override
  Future<Either<Failure, OrderReceiptResponseModel>> orderReceipt(
      FormData formData) async {
    try {
      final data = await dataSource.orderReceipt(formData);
      return Right(data);
    } on DioException catch (e) {
      logMe("Failure Submit Ratings repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
