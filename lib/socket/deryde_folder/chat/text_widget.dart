import 'package:flutter/material.dart';

/// This is the CommonTextWidget [text] widget
///
/// with a [msg] text and a [font] fontFamily and a [textSize]
///
/// fontSize and a [color] color and a [maxLine] maxLines and a [textAlign]
///
/// textAlignment and a [fontWeight] fontWeight
///
/// The [requiredParam] parameter is required and cannot be null.
class TextWidget extends StatelessWidget {
  String? msg;
  String? font;
  double? textSize;
  Color? color;
  int? maxLine;
  TextAlign? textAlign;
  FontWeight? fontWeight;
  TextOverflow? overflow;
  TextWidget(
      {Key? key,
      this.msg,
      this.fontWeight,
      this.font,
      this.textSize,
      this.color,
      this.textAlign,
      this.overflow,
      this.maxLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg ?? "",
      maxLines: maxLine ?? 5,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      style: TextStyle(
          fontFamily: font,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontSize: textSize,
          color: color),
    );
  }
}
