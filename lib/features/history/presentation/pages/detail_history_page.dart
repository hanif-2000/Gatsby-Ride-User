import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_app_title_bar.dart';
import '../../../../core/static/styles.dart';
import '../../data/models/history_response_model.dart';

class DetailHistoryPage extends StatefulWidget {
  final HistoryOrder item;
  static const String routeName = "DetailHistoryPage";
  const DetailHistoryPage({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String orderDate = getDateString(widget.item.orderTime);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: greyColor,
        appBar: CustomAppTtitleBar(
          centerTitle: true,
          canBack: true,
          title: appLoc.historyDetail.toUpperCase(),
          hideShadow: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 50,
                  color: shadowColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 2,
                            child: AutoSizeText(
                              orderDate,
                              maxLines: 1,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: AutoSizeText(
                              getHistoryStatus(widget.item.status),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: formTextFieldStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    color: whiteColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, bottom: 0, right: 10.0),
                          child: Container(
                              decoration: const BoxDecoration(
                                color: whiteColor,
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(
                                      Icons.my_location,
                                      color: primaryColor,
                                      size: 35,
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            appLoc.startingPoint,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontFamily: 'Hiragino Kaku',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 2.0),
                                        Flexible(
                                          child: Text(widget.item.startAddress,
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: 'Hiragino Kaku',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Divider()),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 10.0, bottom: 10.0, right: 10.0),
                          child: Container(
                              color: whiteColor,
                              child: Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(
                                      Icons.location_on,
                                      color: primaryColor,
                                      size: 35,
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            appLoc.destination,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontFamily: 'Hiragino Kaku',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 2.0),
                                        Flexible(
                                          child: Text(widget.item.endAddress,
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: 'Hiragino Kaku',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      color: whiteColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mediumVerticalSpacing(),
                            Text(
                              appLoc.paymentMethod,
                              style: const TextStyle(
                                  fontFamily: 'Yu Ghotic',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            smallVerticalSpacing(),
                            Text(
                              getPaymentMethod(widget.item),
                            ),
                            mediumVerticalSpacing(),
                          ],
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: 200,
                    color: whiteColor,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: constraints.maxHeight * 0.65,
                                decoration: const BoxDecoration(
                                  color: whiteColor,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: secondaryColor, width: 0.3)),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(appLoc.distance,
                                            style: const TextStyle(
                                                fontFamily: 'Yu Ghotic',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        Text(mergeDistanceTxt(
                                            widget.item.distance))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(appLoc.typeOfTaxi,
                                            style: const TextStyle(
                                                fontFamily: 'Yu Ghotic',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        Text(
                                            mergeTypeTaxi(widget.item.category))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(appLoc.price,
                                            style: const TextStyle(
                                                fontFamily: 'Yu Ghotic',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        Text(mergePriceTxt(widget.item.total))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(appLoc.total,
                                        style: const TextStyle(
                                            fontFamily: 'Yu Ghotic',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: primaryColor)),
                                    Text(mergePriceTxt(widget.item.total),
                                        style: const TextStyle(
                                            fontFamily: 'Yu Ghotic',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: primaryColor)),
                                  ])
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
