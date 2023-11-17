import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RideCanceledDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              // width: 200,
              decoration: BoxDecoration(
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
                      "Driver Canceled the Ride",
                      maxFontSize: 22,
                      minFontSize: 9,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Hiragino Kaku',
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      "Find Next Driver",
                      maxFontSize: 18,
                      minFontSize: 9,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Hiragino Kaku',
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
