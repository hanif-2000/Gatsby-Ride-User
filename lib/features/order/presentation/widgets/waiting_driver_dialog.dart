import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WaitingDriverDialog extends StatelessWidget {
  final BoxConstraints? size;

  const WaitingDriverDialog({Key? key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size!.maxHeight * 0.3,
          width: size!.maxWidth * 0.8,
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35)),
            // border: Border(
            //     bottom: BorderSide(color: HexColor('#707070'), width: 0.3)),
          ),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  appLoc.weAreArrangingTaxiNow,
                  maxFontSize: 15,
                  minFontSize: 15,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Hiragino Kaku',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                AutoSizeText(
                  appLoc.pleaseWait,
                  maxFontSize: 15,
                  minFontSize: 15,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Hiragino Kaku',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
        ),
      ],
    );
  }
}
