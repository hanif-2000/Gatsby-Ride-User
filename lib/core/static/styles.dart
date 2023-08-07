import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/static/dimens.dart';
import 'package:flutter/material.dart';
import '../types/fonts.dart';

TextStyle labelAppBar = const TextStyle(
        fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold)
    .useHiraginoKakuW3Font();

TextStyle labelTitleAppBar = const TextStyle(
        fontSize: 9.0, color: Colors.white, fontWeight: FontWeight.normal)
    .useHiraginoKakuW3Font();

TextStyle distanceTextStyle = const TextStyle(
        fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.normal)
    .useHiraginoKakuW3Font();

TextStyle selectPamyemntStyle = const TextStyle(
        fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w300)
    .useHiraginoKakuW3Font();

TextStyle paymentLabelStyle = const TextStyle(
        fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w500)
    .useHiraginoKakuW3Font();

TextStyle txtButtonStyle = const TextStyle(
        fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)
    .useHiraginoKakuW6Font();
TextStyle txtButtonCancelStyle = const TextStyle(
        fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)
    .useHiraginoKakuW6Font();
TextStyle txtButtonProfileStyle = const TextStyle(
        fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)
    .useHiraginoKakuW6Font();

TextStyle searchBarInputTextStyle =
    const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)
        .useHiraginoKakuW3Font();

TextStyle searchBarHintTextStyle =
    const TextStyle(fontSize: 14.0).useHiraginoKakuW3Font();

TextStyle priceTextStyle = const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: primaryColor)
    .useHiraginoKakuW6Font();

TextStyle formLabelStyle = const TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)
    .useHiraginoKakuW3Font();

TextStyle formLabelHeaderStyle = const TextStyle(
        fontSize: fontMedium, color: Colors.black, fontWeight: FontWeight.bold)
    .useHiraginoKakuW6Font();
TextStyle versionAppHeadTextStyle = const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: blackColor)
    .useHiraginoKakuW6Font();
TextStyle versionAppTextStyle = const TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: greyBlackColor)
    .useHiraginoKakuW6Font();

TextStyle formTextFieldStyle =
    const TextStyle(fontSize: 14, color: Colors.black).useHiraginoKakuW6Font();

TextStyle whiteAccentStyle =
    const TextStyle(fontSize: 12, color: blackColor).useHiraginoKakuW6Font();

TextStyle titleStyle = const TextStyle(
        fontSize: fontExtraLarge,
        color: Colors.black,
        fontWeight: FontWeight.bold)
    .useHiraginoKakuW6Font();

TextStyle appBarStyle(Color? textColor) =>
    TextStyle(fontSize: 16.0, color: textColor ?? Colors.white)
        .useHiraginoKakuW6Font();

TextStyle titlePlatStyle =
    const TextStyle(fontSize: 16, color: Colors.black).useHiraginoKakuW6Font();

TextStyle titleModelStyle =
    const TextStyle(fontSize: 14, color: Colors.black).useHiraginoKakuW6Font();

TextStyle titleNameStyle =
    const TextStyle(fontSize: 13, color: Colors.black).useHiraginoKakuW3Font();
