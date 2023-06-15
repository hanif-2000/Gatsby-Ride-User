import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPaymentTile extends StatelessWidget {
  const CustomPaymentTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: _deviceSize.width * .05,
              ),
              child: SvgPicture.asset('assets/icons/cash.svg'),
            ),
            const Text(
              "Cash",
              style: TextStyle(
                fontFamily: 'poPPinMedium',
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: _deviceSize.width * .02),
          child: SvgPicture.asset('assets/icons/grey-disclosure.svg'),
        ),
      ],
    );
  }
}
