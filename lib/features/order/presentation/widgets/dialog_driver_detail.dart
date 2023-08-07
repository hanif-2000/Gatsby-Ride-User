import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/order/domain/entities/driver_detail.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DriverFoundDialog extends StatelessWidget {
  // final String msg;
  final DriverDetail driverDetail;
  final Function onTap;

  const DriverFoundDialog({
    Key? key,
    required this.driverDetail,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        child: Container(
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
                      topRight: Radius.circular(35)),
                  // border: Border(
                  //     bottom: BorderSide(color: HexColor('#707070'), width: 0.3)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: AutoSizeText(
                            appLoc.youGetTaxi,
                            maxFontSize: 22,
                            minFontSize: 10,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: 'Hiragino Kaku',
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: AutoSizeText(
                              appLoc.driverName,
                              maxFontSize: 14,
                              minFontSize: 9,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Hiragino Kaku',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                            Expanded(
                                child: AutoSizeText(
                              driverDetail.name,
                              maxFontSize: 14,
                              minFontSize: 9,
                              maxLines: 2,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontFamily: 'Hiragino Kaku',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: AutoSizeText(
                              appLoc.phoneNumber,
                              maxFontSize: 14,
                              minFontSize: 9,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Hiragino Kaku',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                            Expanded(
                                child: AutoSizeText(
                              driverDetail.phone,
                              maxFontSize: 14,
                              minFontSize: 9,
                              maxLines: 2,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontFamily: 'Hiragino Kaku',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: AutoSizeText(
                              appLoc.carModel,
                              maxFontSize: 14,
                              minFontSize: 9,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Hiragino Kaku',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                            Expanded(
                                child: AutoSizeText(
                              driverDetail.model,
                              maxFontSize: 14,
                              minFontSize: 9,
                              maxLines: 2,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontFamily: 'Hiragino Kaku',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: AutoSizeText(
                              appLoc.platNumber,
                              maxFontSize: 14,
                              minFontSize: 9,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Hiragino Kaku',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                            Expanded(
                                child: AutoSizeText(
                              driverDetail.plat,
                              maxFontSize: 14,
                              minFontSize: 9,
                              maxLines: 2,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontFamily: 'Hiragino Kaku',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.3,
                color: secondaryColor,
              ),
              Container(
                height: 200 * 0.3,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Text(appLoc.ok,
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'Hiragino Kaku',
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      onTap: () => onTap(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
