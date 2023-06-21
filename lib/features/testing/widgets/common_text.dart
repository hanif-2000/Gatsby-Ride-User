import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  String? text;
  double? fontSize;
  String? fontFamily;
  Color? fontColor;
  FontWeight? fontWeight;

  CommonText(
      {Key? key,
      this.text,
      this.fontColor,
      this.fontFamily,
      this.fontSize,
      this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        fontFamily: fontFamily ?? "poPPinMedium",
        fontWeight: fontWeight,
        color: fontColor ?? blackColor,
        fontSize: fontSize,
      ),
      textAlign: TextAlign.center,
    );
  }
}
