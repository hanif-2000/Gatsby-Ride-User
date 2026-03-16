import 'dart:developer';

import 'package:GetsbyRideshare/core/domain/entities/vehcles_category_list.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/core/utility/injection.dart';
import 'package:GetsbyRideshare/core/utility/session_helper.dart';
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
  //   String url = '';

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
    log("get vehicle catagory called");
    Session session = locator<Session>();
    FormData data = FormData.fromMap({
      'distance': distance,
      'night_service': nightService,
      'coordinates': coordinates,
      'time': time,
      'user_id': session.userId
    });
    String url = 'api/webservice/priceCategory';

    log("fetch vehicle catagory list body:---> ${data.fields} ");

try {
  final response = await dio.post(
    url,
    data: data,
  );

  log("bikbbu" + response.data.toString());
  log("Complete Url=========>>>>>>" + response.realUri.path);

  if ((response.data["success"] == 0) &&
      (response.data["message"] == "Account Suspended")) {
    showToast(message: 'Account Suspended');
  }
  
  // ADD THIS DEBUG LOG
  log("=== PARSING START ===");
  final result = VehiclesCategoryListModel.fromJson(response.data);
  log("=== PARSING SUCCESS === Items: ${result.data.length}");
  for(var item in result.data) {
    log("Parsed vehicle: ${item.categoryCar}");
  }
  return result;
  
} catch (e, stackTrace) {  // ADD stackTrace
  log("VehiclesCategoryListModel detail Error VehiclesDataSourceImplementation : ",
      error: e);
  log("Stack trace: $stackTrace");  // ADD THIS
  rethrow;
}
  }
}
