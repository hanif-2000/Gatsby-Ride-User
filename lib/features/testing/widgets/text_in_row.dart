import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';

class TextInRow extends StatelessWidget {
  final String? firstText;
  final String? secondText;
  final FontWeight? secondTextweight;
  const TextInRow(
      {Key? key, this.firstText, this.secondText, this.secondTextweight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: firstText,
          fontWeight: FontWeight.w500,
          fontColor: grey7C7C7CColor,
          fontFamily: "poPPinMedium",
          fontSize: 16,
        ),
        CommonText(
          text: secondText,
          fontWeight: secondTextweight ?? FontWeight.w500,
          fontColor: blue242E42Color,
          fontFamily: "poPPinMedium",
          fontSize: 16,
        ),
      ],
    );
  }
}
