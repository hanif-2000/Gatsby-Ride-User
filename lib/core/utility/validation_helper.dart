import 'package:flutter/material.dart';
import 'package:GetsbyRideshare/l10n/generated/app_localizations.dart';
import '../static/enums.dart';
import 'helper.dart';

class ValidationHelper {
  final AppLocalizations loc;
  final Function(bool value) isError;
  final TypeField typeField;
  final String?
      pwd; // this value for matching between 'confirmation password' with 'password'

  ValidationHelper({
    required this.loc,
    this.pwd = '',
    required this.isError,
    required this.typeField,
  });

  FormFieldValidator validate() {
    String? message;
    return (value) {
      final strValue = value as String;
      if (strValue.isEmpty) {
        message = appLoc.mustNotEmpty;
        isError(true);
      }


      else {
        switch (typeField) {
          case TypeField.email:
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp emailRegex = RegExp(pattern.toString());
            if (!emailRegex.hasMatch(strValue)) {
              message = appLoc.emailInvalid;
              isError(true);
            } else {
              isError(false);
            }
            break;
          case TypeField.password:
            Pattern pattern =
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
            RegExp passwordRegex = RegExp(pattern.toString());
            if (!passwordRegex.hasMatch(strValue)) {
              message = "Password should contain Capital, small letter & Number & Special";
              // message = appLoc.pas;
              isError(true);
            } else {
              isError(false);
            }
            break;
          default:
            isError(false);
        }
      }
      return message;
    };
  }
}
