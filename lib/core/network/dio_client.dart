import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';

import '../utility/app_settings.dart';
import 'app_interceptor.dart';

class DioClient {
  static late Dio _dio;
  final AppInterceptor appInterceptor = AppInterceptor();
  addInterception() {
    _dio.interceptors.addAll([appInterceptor, dioLoggerInterceptor]);
  }

  DioClient({String base = BASE_URL}) {
    _dio = Dio(BaseOptions(
      baseUrl: base,
      validateStatus: (status) => (status! >= 200) && (status <= 422),
    ));
    addInterception();
  }

  Dio get dio => _dio;
}
