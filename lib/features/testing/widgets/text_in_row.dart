import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';

class TextInRow extends StatelessWidget {
  final String? firstText;
  final String? secondText;
  final FontWeight? secondTextweight;
  final FontWeight? titleFontWeight;
  const TextInRow(
      {Key? key, this.firstText, this.secondText, this.secondTextweight,this.titleFontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: firstText,
          fontWeight: titleFontWeight??FontWeight.w500,
          fontColor:titleFontWeight == null? grey7C7C7CColor:blue242E42Color,
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
