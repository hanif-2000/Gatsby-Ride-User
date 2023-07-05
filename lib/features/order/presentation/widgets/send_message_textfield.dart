import 'package:appkey_taxiapp_user/core/static/assets.dart';
import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../socket/socket_provider.dart';
import 'package:provider/provider.dart';

class SendMessageTextField extends StatelessWidget {
  final VoidCallback onTap;
  const SendMessageTextField({Key? key, required this.onTap}) : super(key: key);

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
              controller: Provider.of<SocketProvider>(context, listen: true)
                  .msgEditingController,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: appLoc.enterMessage,
                hintStyle: TextStyle(
                    color: blackColor,
                    fontFamily: 'poPPinRegular',
                    fontSize: 14.0),
              ),
            )),
            InkWell(
              onTap: onTap,
              child: SvgPicture.asset(
                sendIcon,
              ),
            )
          ],
        ),
      ),
    );
  }
}
