import 'package:appkey_taxiapp_user/core/static/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'helper.dart';

extension DynamicHeader on Dio {
  Dio withToken({String? token}) {
    if (token != null) {
      return this..options.headers.addAll({"Authorization": "Bearer $token"});
    }
    return this..options.headers.addAll({'required_token': true});
  }
}

// Font Families

extension CustomFontFamily on TextStyle {
  TextStyle useHiraginoKakuW3Font() {
    const String fontName = 'Hiragino Kaku';
    return merge(
        const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w300));
  }

  TextStyle useHiraginoKakuW6Font() {
    const String fontName = 'Hiragino Kaku';
    return merge(
        const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w600));
  }

  TextStyle useHiraginoMaruW4Font() {
    const String fontName = 'Hiragino Maru';
    return merge(
        const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w400));
  }
}

extension LocalizationString on PaymentMethod {
  String getString() {
    switch (this) {
      case PaymentMethod.cash:
        return appLoc.cash;
      case PaymentMethod.creditCard:
        return appLoc.creditDebit;
      case PaymentMethod.applePay:
        return "Apple Pay";
      case PaymentMethod.googlePay:
        return 'Google Pay';
    }
  }
}
