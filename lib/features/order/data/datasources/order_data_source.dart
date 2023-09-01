import 'package:GetsbyRideshare/core/utility/extension.dart';
import 'package:GetsbyRideshare/features/order/data/models/detail_driver_response.dart';
import 'package:GetsbyRideshare/features/order/data/models/detail_order_response_model.dart';
import 'package:GetsbyRideshare/features/order/data/models/order_receipt_response_modal.dart';
import 'package:GetsbyRideshare/features/order/domain/entities/driver_detail.dart';
import 'package:GetsbyRideshare/features/order/domain/entities/order_detail.dart';
import 'package:dio/dio.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../models/create_order_response_model.dart';
import '../models/driver_location_response_model.dart';
import '../models/get_status_response.dart';
import '../models/status_oder_response_model.dart';
import '../models/submit_rating_response_modal.dart';

abstract class OrderDataSource {
  Future<CreateOrderResponseModel> createOrder(FormData formData);
  Future<UpdateStatusOrderResponseModel> updateStatusOrder(FormData formData);
  Future<SubmitRatingsResponseModel> submitRatings(FormData formData);
  Future<OrderReceiptResponseModel> orderReceipt(FormData formData);

  Future<GetStatusResponseModel> getStatusOrder();
  Future<OrderDetail> getDetailOrder();
  Future<DriverDetail> getDriverDetail();
  Future<DriverLocationResponseModel> getDriverLocation();
  // Future<OrderPaymentResponseModal> orderPayment();
}

class OrderDataSourceImplementation implements OrderDataSource {
  final Dio dio;

  OrderDataSourceImplementation({required this.dio});

  @override
  Future<CreateOrderResponseModel> createOrder(FormData formData) async {
    String url = 'api/webservice/send_order';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = CreateOrderResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

//Update Status ORDER
  @override
  Future<UpdateStatusOrderResponseModel> updateStatusOrder(
      FormData formData) async {
    String url = 'api/webservice/updateStatus';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = UpdateStatusOrderResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GetStatusResponseModel> getStatusOrder() async {
    final session = locator<Session>();
    String orderId = session.orderId;
    String url = 'api/webservice/order-status-user/$orderId';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = GetStatusResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderDetail> getDetailOrder() async {
    final session = locator<Session>();
    String orderId = session.orderId;
    String url = 'api/webservice//getOrder?id=$orderId';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = OrderDetailResponseModel.fromJson(response.data);
      return model.data;
    } catch (e) {
      rethrow;
    }
  }

//GET Driver details while order Ride
  @override
  Future<DriverDetail> getDriverDetail() async {
    final session = locator<Session>();
    String driverId = session.driverId;
    String url = 'api/webservice/driver-profile?id=$driverId';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = DriverDetailResponseModel.fromJson(response.data);
      return model.data;
    } catch (e) {
      rethrow;
    }
  }

//Get Driver Location
  @override
  Future<DriverLocationResponseModel> getDriverLocation() async {
    final session = locator<Session>();
    String driverId = session.driverId;
    String url = 'api/webservice/driver_location?id=$driverId';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = DriverLocationResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  //Submit Ratings

  @override
  Future<SubmitRatingsResponseModel> submitRatings(FormData formData) async {
    String url = 'api/webservice/order/rating';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = SubmitRatingsResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  // Order Receipt

  @override
  Future<OrderReceiptResponseModel> orderReceipt(FormData formData) async {
    String url = 'api/webservice/customer/order/receipt';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = OrderReceiptResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

//   @override
//   Future<OrderPaymentResponseModal> orderPayment(FormData formData) async {
//       String url = 'api/webservice/customer/order/receipt';
//     dio.withToken();
//     try {
//       final response = await dio.post(
//         url,
//         data: formData,
//       );
//       final model = OrderPaymentResponseModal.fromJson(response.data);
//  return model;
//  } catch (e) {
//       rethrow;
//     }
//   }

  // // payment order

  // @override
  // Future<OrderPaymentResponseModal> orderPayment(FormData formData) async {
  //   String url = 'api/webservice/payment';
  //   dio.withToken();
  //   try {
  //     final response = await dio.post(
  //       url,
  //       data: formData,
  //     );
  //     final model = OrderPaymentResponseModal.fromJson(response.data);
  //     return model;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
