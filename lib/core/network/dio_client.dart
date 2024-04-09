import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../utility/app_settings.dart';
import 'app_interceptor.dart';

class DioClient {
  static late Dio _dio;
  final AppInterceptor appInterceptor = AppInterceptor();
  addInterception() {
    _dio.interceptors.addAll([appInterceptor],);
    _dio.interceptors.add(LoggingInterceptors());
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

class LoggingInterceptors extends Interceptor {
  String printObject(Object object) {
    // Encode your object and then decode your object to Map variable
    Map jsonMapped = json.decode(json.encode(object));

    // Using JsonEncoder for spacing
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');

    // encode it to string
    String prettyPrint = encoder.convert(jsonMapped);
    return prettyPrint;
  }

  String hitUrl = "";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("on reguest called ------------");
    hitUrl = options.path;
    // "${options.method.toUpperCase()} ${"" + (options.baseUrl) + (options.path)}";
    print(" API URL ✈️✈️✈️✈ ️--> $hitUrl");
    options.headers.forEach((k, v) => print('$k: $v'));
    print("queryParameters:");
    options.queryParameters.forEach((k, v) => print('$k: $v'));
    if (options.data != null) {
      try {
        // print("Body: ${printObject(options.data)}");
        FormData formData = options.data as FormData;
        print("Body: ${formData.fields}");
        var buffer = [];
        for (MapEntry<String, String> pair in formData.fields) {
          buffer.add('${pair.key}:${pair.value}');
        }
        print("Body 💪💪💪 =====:{${buffer.join(', ')}}");
      } catch (e) {
        print("Body 💪💪💪 ====: ${printObject(options.data)}");
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
        "<------------ ${err.message} ${(err.response?.requestOptions != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')} ---"
        '\nDioException');
    print("${err.response != null ? err.response!.data : 'Unknown Error'}"
        'DioException');

    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("Response for $hitUrl👉👉👉👉👉: ${response.data}");
    print("<----- END 👍 HTTP ----->");
    return super.onResponse(response, handler);
  }
}
