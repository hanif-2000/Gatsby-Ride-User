import 'package:GetsbyRideshare/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:flutter/material.dart';

class RateNowWidget extends StatelessWidget {
  const RateNowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
      ),
      child: Row(children: [
        Text(
          "Rating not given yet",
          style: TextStyle(
            fontFamily: 'poPPinMedium',
            fontSize: 14.0,
          ),
        ),
        CustomButton(
          buttonHeight: 50.0,
          isRounded: true,
          text: "Rate Now",
          event: () {},
          bgColor: blackColor,
        )
      ]),
    );
  }
}
