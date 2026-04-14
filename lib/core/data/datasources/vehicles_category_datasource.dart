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

    try {
      // Step 1: Get all vehicle categories
      final categoriesResponse = await dio.get('api/webservice/vehicleCategories');
      log("vehicleCategories response: ${categoriesResponse.data}");

      final List<dynamic> categories = categoriesResponse.data['data'] ?? [];

      // Step 2: For each category, fetch calculated price
      final List<Map<String, dynamic>> enrichedCategories = await Future.wait(
        categories.map((cat) async {
          try {
            final priceResponse = await dio.post(
              'api/webservice/priceCategory',
              data: {
                'vehicle_category_id': cat['id'],
                'distance': double.tryParse(distance) ?? 0.0,
              },
              options: Options(headers: {'content-type': 'application/json'}),
            );
            final priceData = priceResponse.data['data'];
            final total = priceData['total']?.toString() ?? '0';
            return {
              ...Map<String, dynamic>.from(cat),
              'price': total,
              'new_total': total,
              'estimated_distance': distance,
              'estimated_time': time,
            };
          } catch (e) {
            log("Price fetch failed for category ${cat['id']}: $e");
            return Map<String, dynamic>.from(cat);
          }
        }),
      );

      final result = VehiclesCategoryListModel.fromJson({
        'success': 1,
        'data': enrichedCategories,
      });

      log("=== Categories loaded: ${result.data.length} ===");
      return result;
    } catch (e, stackTrace) {
      log("VehiclesCategoryListModel Error: ", error: e);
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }
}
