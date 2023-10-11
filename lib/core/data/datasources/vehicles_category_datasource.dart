import 'dart:developer';

import 'package:GetsbyRideshare/core/domain/entities/vehcles_category_list.dart';
import 'package:dio/dio.dart';

import '../models/vehicles_catagory_list_modal.dart';

abstract class VehicleCategoryDataSource {
  Future<VehiclesCategoryList> getVehiclesCategoryList(
      String distance, String nightService, String coordinates, String time);
}

class VehicleCategoryDataSourceImplementation
    implements VehicleCategoryDataSource {
  final Dio dio;

  VehicleCategoryDataSourceImplementation({required this.dio});

  // @override
  // Future<VehicleCategoryResponseModal> getVehicleCategoryList(
  //   String distance,
  //   String nightService,
  //   String coordinates,
  // ) async {
  //   FormData data = FormData.fromMap({
  //     'distance': distance,
  //     'night_service': nightService,
  //     'coordinates': coordinates
  //   });
  //   String url = 'api/webservice/priceCategory';

  //   try {
  //     // final response = await dio.post(path,data: formdata);
  //     final response = await dio.post(
  //       url,
  //       data: data,
  //     );

  //     log("bikbbu" + response.data.toString());
  //     return VehicleCategoryResponseModal.fromJson(response.data);
  //     // return VehicleCategoryModal.fromJson(response.data);
  //   } catch (e) {
  //     log("PriceCategoryListModel detail Error PriceCategoryDataSourceImplementation : ",
  //         error: e);
  //     rethrow;
  //   }
  // }

  @override
  Future<VehiclesCategoryList> getVehiclesCategoryList(
    String distance,
    String nightService,
    String coordinates,
    String time,
  ) async {
    FormData data = FormData.fromMap({
      'distance': distance,
      'night_service': nightService,
      'coordinates': coordinates,
      'time': time
    });
    String url = 'api/webservice/priceCategory';

    log("fetch vehicle catagory list body:---> ${data.fields} ");

    try {
      // final response = await dio.post(path,data: formdata);
      final response = await dio.post(
        url,
        data: data,
      );

      log("bikbbu" + response.data.toString());
      return VehiclesCategoryListModel.fromJson(response.data);
      // return VehicleCategoryModal.fromJson(response.data);
    } catch (e) {
      log("VehiclesCategoryListModel detail Error VehiclesDataSourceImplementation : ",
          error: e);
      rethrow;
    }
  }
}
