import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SettingsProvider extends ChangeNotifier{
  final Dio _dio = Dio();
  Future<dynamic> logoutApi(){
    final String logOut = "https://php.parastechnologies.in/taxi/public/api/webservice/logout";
     Response response = _dio.get(logOut,options:Op );


  }

}
