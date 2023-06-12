import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/history/data/models/history_response_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pages/detail_history_page.dart';

class HistoryItem extends StatefulWidget {
  final HistoryOrder data;

  const HistoryItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  @override
  Widget build(BuildContext context) {
    String orderDate = getDateString(widget.data.orderTime);

    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailHistoryPage.routeName,
              arguments: widget.data);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          height: 200,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: greyEFEFEFColor.withOpacity(1),
                spreadRadius: -10,
                blurRadius: 10,
                offset: const Offset(-10, 10), // changes position of shadow
              ),
            ],
          ),
          child: LayoutBuilder(builder: (context, constraint) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    height: constraint.maxHeight * 0.25,
                    decoration: BoxDecoration(
                        color: whiteColor.withOpacity(.8),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 2,
                                child: AutoSizeText(
                                  orderDate,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: blackColor,
                                    fontSize: 14.0,
                                    fontFamily: 'poPPinMedium',
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    (getHistoryStatus(widget.data.status) ==
                                            "Cancelled")
                                        ? SvgPicture.asset(
                                            'assets/icons/red_dot.svg')
                                        : SvgPicture.asset(
                                            'assets/icons/green_dot.svg'),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    AutoSizeText(
                                      getHistoryStatus(widget.data.status),
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: (getHistoryStatus(
                                                    widget.data.status) ==
                                                "Cancelled")
                                            ? redf52d56Color
                                            : green2DAA5FColor,
                                        fontSize: 14.0,
                                        fontFamily: 'poPPinMedium',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                Container(
                    height: constraint.maxHeight * 0.4,
                    decoration: const BoxDecoration(
                      color: whiteColor,
                      border: Border(
                          bottom:
                              BorderSide(color: secondaryColor, width: 0.5)),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            SizedBox(
                              height: constraint.maxHeight,
                              width: constraint.maxWidth * 0.7,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: SvgPicture.asset(
                                          'assets/icons/color_location_logo.svg',
                                          height: 22,
                                          width: 22,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget.data.startAddress,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: blackColor,
                                            fontSize: 14.0,
                                            fontFamily: 'poPPinMedium',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: SvgPicture.asset(
                                          'assets/icons/destination_logo.svg',
                                          height: 22,
                                          width: 22,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget.data.endAddress,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: blackColor,
                                            fontSize: 14.0,
                                            fontFamily: 'poPPinMedium',
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: constraint.maxHeight,
                              width: constraint.maxWidth * 0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Flexible(
                                    child: AutoSizeText(
                                      "Total Fare",
                                      style: TextStyle(
                                          color: blackColor,
                                          fontFamily: 'poPPinMedium',
                                          fontSize: 14),
                                    ),
                                  ),
                                  Flexible(
                                    child: AutoSizeText(
                                      mergePriceTxt(widget.data.total),
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: blackColor,
                                          fontFamily: 'poPPinSemiBold',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    )),
                Container(
                    height: constraint.maxHeight * 0.35,
                    decoration: const BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            SizedBox(
                              height: constraint.maxHeight,
                              width: constraint.maxWidth * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        appLoc.taxiType,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: blackColor,
                                          fontSize: 14.0,
                                          fontFamily: 'poPPinMedium',
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        appLoc.paymentMethod,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: blackColor,
                                          fontSize: 14.0,
                                          fontFamily: 'poPPinMedium',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: constraint.maxHeight,
                              width: constraint.maxWidth * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: AutoSizeText(
                                        mergeTypeTaxi(widget.data.category),
                                        // overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: blackColor,
                                          fontSize: 14.0,
                                          fontFamily: 'poPPinMedium',
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Flexible(
                                      child: AutoSizeText(
                                        getPaymentMethod(widget.data),
                                        maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: blackColor,
                                          fontSize: 14.0,
                                          fontFamily: 'poPPinMedium',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    )),
              ],
            );
          }),
        )
        // child: Container(
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             topRight: Radius.circular(20))),
        //     child: Text('asd'))),
        );
  }
}
