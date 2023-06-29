import 'package:appkey_taxiapp_user/core/static/assets.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SendMessageTextField extends StatelessWidget {
  const SendMessageTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.1),
              blurRadius: 0.5,
              spreadRadius: 1.0,
              offset: Offset(
                0.0,
                0.0,
              ),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Enter message...",
                hintStyle: TextStyle(
                    color: blackColor,
                    fontFamily: 'poPPinRegular',
                    fontSize: 14.0),
              ),
            )),
            SvgPicture.asset(
              sendIcon,
            )
          ],
        ),
      ),
    );
  }
}
