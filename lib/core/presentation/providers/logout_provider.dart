import 'package:GetsbyRideshare/core/network/dio_client.dart';
import 'package:GetsbyRideshare/core/static/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LogOutProvider extends ChangeNotifier {
  final Dio _dio = DioClient().dio;

  Future<bool> logOutUser() async{
    try {
      final String url = "https://php.parastechnologies.in/taxi/public/api/webservice/logout";
      _dio.withToken();
      Response response = await _dio.get(url,);
      if (response.statusCode == 200 && response.data["message"] == "Logout successfully") {
       return true;
      } else {

        return false;
      }
    } catch (e,t) {
      print(e);
      print(t);
      return false;
    }
  }


}