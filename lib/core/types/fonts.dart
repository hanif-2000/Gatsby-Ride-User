import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appFont(
  BuildContext context, {
  TextStyle? textStyle,
  FontWeight fontWeight = FontWeight.w400,
  FontStyle fontStyle = FontStyle.normal,
  Color color = Colors.black,
  int alpha = 255,
  double? size,
  double? height,
  double? letterSpacing,
  double? wordSpacing,
  TextDecorationStyle? decorationStyle,
  TextDecoration textDecoration = TextDecoration.none,
}) {
  return GoogleFonts.notoSans(
    textStyle: textStyle ?? Theme.of(context).textTheme.bodyText2,
    fontWeight: FontWeight.w600,
    height: height,
    letterSpacing: letterSpacing,
    fontStyle: FontStyle.normal,
    color: color.withAlpha(alpha),
    wordSpacing: wordSpacing,
    decorationStyle: decorationStyle,
    decoration: textDecoration,
  );
}

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


  TextStyle usePoPPinSemiBoldW6Font() {
    const String fontName = 'poPPinSemiBold';
    return merge(
        const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w600));
  }
}
