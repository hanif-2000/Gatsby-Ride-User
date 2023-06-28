import 'dart:developer';

import 'package:appkey_taxiapp_user/core/static/colors.dart';
import 'package:appkey_taxiapp_user/core/utility/helper.dart';
import 'package:appkey_taxiapp_user/features/order/presentation/providers/order_provider.dart';
import 'package:appkey_taxiapp_user/features/testing/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../../core/static/assets.dart';
import '../../../../testing/widgets/circular_image_container.dart';
import '../../../../testing/widgets/text_in_row.dart';
import '../../providers/get_receipt_state.dart';
import 'feedback_screen.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.of(context).size.height;
    double? width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              elevation: 0.3,
              backgroundColor: whiteColor,
              centerTitle: true,
              title: CommonText(
                text: "Receipt",
                fontWeight: FontWeight.w600,
                fontColor: blackColor,
                fontFamily: "poPPinMedium",
                fontSize: 18,
              ),
            ),
            body: StreamBuilder<GetReceiptState>(
              stream: context.read<OrderProvider>().orderReceiptApi(),
              builder: (context, state) {
                switch (state.data.runtimeType) {
                  case GetReceiptLoading:
                    return const Center(child: CircularProgressIndicator());

                  case GetReceiptFailure:
                    final failure = (state.data as GetReceiptFailure).failure;
                    dismissLoading();

                    // showToast(message: failure);
                    return const SizedBox.shrink();

                  case GetReceiptLoaded:
                    final data = (state.data as GetReceiptLoaded).data;

                    dismissLoading();

                    DateTime dt1 =
                        DateTime.parse(data.orderReceipt![0].startTime);
                    DateTime dt2 = data.orderReceipt![0].endTime;
                    Duration timeTaken = dt2.difference(dt1);

                    log(timeTaken.toString());
                    log(timeTaken.inHours.toString());
                    log(timeTaken.inMinutes.toString());
                    log(timeTaken.inSeconds.toString());

                    return Container(
                      height: height,
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CommonCircularImageContainer(
                                      height: 45,
                                      width: 45,
                                      image: data.orderReceipt![0].image,
                                    ),
                                    SizedBox(
                                      width: 11,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          text: data.orderReceipt![0].userName,
                                          fontWeight: FontWeight.w500,
                                          fontColor: blackColor,
                                          fontFamily: "poPPinMedium",
                                          fontSize: 16,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(starImage),
                                            CommonText(
                                              text: data.orderReceipt![0].rating
                                                  .toString(),
                                              fontWeight: FontWeight.w600,
                                              fontColor: blackColor,
                                              fontFamily: "poPPinMedium",
                                              fontSize: 14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    CommonText(
                                      text: data.orderReceipt![0].carModel,
                                      fontWeight: FontWeight.w400,
                                      fontColor: grey585858Color,
                                      fontFamily: "poPPinMedium",
                                      fontSize: 12,
                                    ),
                                    CommonText(
                                      text: data.orderReceipt![0].plateNumber,
                                      fontWeight: FontWeight.w500,
                                      fontColor: blackColor,
                                      fontFamily: "poPPinMedium",
                                      fontSize: 12,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            CommonText(
                              text: "Fare Breakdown",
                              fontWeight: FontWeight.w600,
                              fontColor: blackColor,
                              fontFamily: "poPPinMedium",
                              fontSize: 16,
                            ),
                            TextInRow(
                              firstText: 'Date',
                              secondText: DateFormat('dd MMM yyyy')
                                  .format(data.orderReceipt![0].orderTime)
                                  .toString(),
                            ),
                            TextInRow(
                              firstText: 'Time',
                              secondText: DateFormat('h:mma')
                                  .format(data.orderReceipt![0].orderTime)
                                  .toString(),
                            ),
                            TextInRow(
                              firstText: 'Total Distance',
                              secondText: data.orderReceipt![0].distance + "Km",
                            ),
                            TextInRow(
                              firstText: 'time taken',
                              secondText: '30 min',
                            ),
                            CommonText(
                              text: "Payment Information",
                              fontWeight: FontWeight.w600,
                              fontColor: blackColor,
                              fontFamily: "poPPinMedium",
                              fontSize: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonText(
                                  text: "Payment Information",
                                  fontWeight: FontWeight.w500,
                                  fontColor: grey7D7979Color,
                                  fontFamily: "poPPinMedium",
                                  fontSize: 13,
                                ),
                                Row(
                                  children: [
                                    data.orderReceipt![0].paymentMethod == 1
                                        ? SvgPicture.asset(
                                            'assets/icons/cash.svg',
                                            height: 30,
                                            width: 30,
                                            fit: BoxFit.fill,
                                          )
                                        : SvgPicture.asset(
                                            'assets/icons/google.svg',
                                            height: 30,
                                            width: 30,
                                            fit: BoxFit.fill,
                                          ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    CommonText(
                                      text:
                                          data.orderReceipt![0].paymentMethod ==
                                                  1
                                              ? "Cash"
                                              : "Google Pay",
                                      fontWeight: FontWeight.w400,
                                      fontColor: grey7D7979Color,
                                      fontFamily: "poPPinMedium",
                                      fontSize: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: greyB2B2B2Color.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.only(
                                  top: 13, bottom: 13, left: 11, right: 11),
                              child: Column(
                                children: [
                                  TextInRow(
                                    firstText: 'Price',
                                    secondText:
                                        r"$" + "${data.orderReceipt![0].total}",
                                  ),
                                  Divider(
                                    color: whiteAccentColor,
                                  ),
                                  TextInRow(
                                    firstText: 'Service Price',
                                    secondText: r'$0.00',
                                  ),
                                  Divider(
                                    color: whiteAccentColor,
                                  ),
                                  TextInRow(
                                    secondTextweight: FontWeight.w700,
                                    firstText: 'Total Price',
                                    secondText:
                                        r"$" + "${data.orderReceipt![0].total}",
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              text: const Text(
                                "Continue",
                                // appLoc.login.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'poPPinSemiBold',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              event: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FeedBackScreen()));
                              },
                              buttonHeight: 50,
                              // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                              isRounded: true,
                              bgColor: black080809Color,
                            ),
                            SizedBox(
                              height: 0,
                            )
                          ],
                        ),
                      ),
                    );
                }
                return const SizedBox.shrink();
              },
            )));
  }
}
