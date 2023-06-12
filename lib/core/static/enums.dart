import 'package:dio/dio.dart';

extension DynamicHeader on Dio {
  Dio withToken() {
    return this..options.headers.addAll({'required_token': true});
  }

  Dio withFcmAuthorization(String key) {
    return this..options.headers.addAll({'Authorization': 'key=$key'});
  }
}

enum AddressType { origin, destination }

enum TypeField { email, phone, password, name, confirmPassword }

enum OrderStatus {
  lookingDriver,
  driverAccept,
  departureToCustomerplace,
  arriveAtCustomerPlace,
  customerConfirmation,
  departureToDestination,
  arriveAtDestination,
  complete,
  cancel,
}

enum PaymentMethod { cash, creditCard, applePay, googlePay }

enum dialogStyle { style1, style2 }
