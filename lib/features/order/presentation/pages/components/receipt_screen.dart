import 'dart:developer';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/components/payment_screen.dart';
import 'package:GetsbyRideshare/features/order/presentation/providers/order_provider.dart';
import 'package:GetsbyRideshare/features/testing/widgets/common_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../../core/static/assets.dart';
import '../../../../../core/utility/injection.dart';
import '../../../../../core/utility/session_helper.dart';
import '../../../../testing/widgets/circular_image_container.dart';
import '../../../../testing/widgets/text_in_row.dart';
import '../../providers/get_receipt_state.dart';
import 'package:pay/pay.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  var sessionToken = locator<Session>().sessionToken;

  var _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  Future<void> onGooglePayResult(paymentResult) async {
    // final response = await fetchPaymentIntentClientSecret();
    // final clientSecret = response['clientSecret'];
    // final token = paymentResult['paymentMethodData']['tokenizationData']['token'];
    // final tokenJson = Map.castFrom(json.decode(token));

    // final params = PaymentMethodParams.cardFromToken(
    //   token: tokenJson['id'],
    // );
    // // Confirm Google pay payment method
    // await Stripe.instance.confirmPayment(
    //   clientSecret,
    //   params,
    // );
  }
  //   debugPrint(paymentResult.toString());
  // }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset('default_google_pay_config.json');
  }

  var dio = Dio();

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
            text: appLoc.receipt,
            fontWeight: FontWeight.w600,
            fontColor: blackColor,
            fontFamily: "poPPinMedium",
            fontSize: 18,
          ),
        ),
        body: StreamBuilder<GetReceiptState>(
          stream: context.read<OrderProvider>().orderReceiptApi(),
          builder: (context, state) {
            log("order state: $state");
            switch (state.data.runtimeType) {
              case GetReceiptLoading:
                log("---->>>Receipt Loading called   <<<<-------");

                return const Center(child: CircularProgressIndicator());

              case GetReceiptFailure:
                final failure = (state.data as GetReceiptFailure).failure;

                showToast(message: failure.toString());

                log("failure is:  $failure");
                dismissLoading();

                // showToast(message: failure);
                return const SizedBox.shrink();

              case GetReceiptLoaded:
                final data = (state.data as GetReceiptLoaded).data;
                log("---->>>Receipt loaded called   <<<<-------");

                log("data is $data");

                dismissLoading();

                DateTime dt1 = DateTime.parse(data.orderReceipt![0].startTime);
                DateTime dt2 = DateTime.parse(data.orderReceipt![0].endTime!);
                int timeTaken = dt2.difference(dt1).inMinutes;

                // int time =
                // (order.endTime!.difference(order.startTime!).inMinutes);

                // log(timeTaken.toString());
                // log(timeTaken.inHours.toString());
                // log(timeTaken.inMinutes.toString());
                // log(timeTaken.inSeconds.toString());

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: data.orderReceipt![0].userName,
                                      fontWeight: FontWeight.w500,
                                      fontColor: blackColor,
                                      fontFamily: "poPPinMedium",
                                      fontSize: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                          text: appLoc.fareBreakdown,
                          fontWeight: FontWeight.w600,
                          fontColor: blackColor,
                          fontFamily: "poPPinMedium",
                          fontSize: 16,
                        ),
                        TextInRow(
                          firstText: appLoc.date,
                          secondText: DateFormat('dd MMM yyyy')
                              .format(data.orderReceipt![0].orderTime)
                              .toString(),
                        ),
                        TextInRow(
                          firstText: appLoc.time,
                          secondText: DateFormat('h:mma')
                              .format(data.orderReceipt![0].orderTime)
                              .toString(),
                        ),
                        TextInRow(
                          firstText: appLoc.totalDistance,
                          secondText: data.orderReceipt![0].distance + "Km",
                        ),
                        TextInRow(
                          firstText: appLoc.timeTaken,
                          secondText: '${timeTaken} min',
                        ),
                        CommonText(
                          text: appLoc.paymentInformation,
                          fontWeight: FontWeight.w600,
                          fontColor: blackColor,
                          fontFamily: "poPPinMedium",
                          fontSize: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              text: appLoc.paymentInformation,
                              fontWeight: FontWeight.w500,
                              fontColor: grey7D7979Color,
                              fontFamily: "poPPinMedium",
                              fontSize: 13,
                            ),
                            Row(
                              children: [
                                data.orderReceipt![0].paymentMethod == 1
                                    ? SvgPicture.asset(
                                        cashIconSvg,
                                        height: 30,
                                        width: 30,
                                        fit: BoxFit.fill,
                                      )
                                    : data.orderReceipt![0].paymentMethod == 2
                                        ? SvgPicture.asset(
                                            creditIcon,
                                            height: 30,
                                            width: 30,
                                            fit: BoxFit.fill,
                                          )
                                        : data.orderReceipt![0].paymentMethod ==
                                                3
                                            ? SvgPicture.asset(
                                                googleIconSvg,
                                                height: 30,
                                                width: 30,
                                                fit: BoxFit.fill,
                                              )
                                            : SvgPicture.asset(
                                                "assets/icons/apple.svg",
                                                height: 30,
                                                width: 30,
                                                fit: BoxFit.fill,
                                              ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                CommonText(
                                  text: data.orderReceipt![0].paymentMethod == 1
                                      ? appLoc.cash
                                      : data.orderReceipt![0].paymentMethod == 2
                                          ? "Credit Card"
                                          : data.orderReceipt![0]
                                                      .paymentMethod ==
                                                  3
                                              ? "Google Pay"
                                              : "Online",
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
                              // TextInRow(
                              //   firstText: appLoc.price,
                              //   secondText:
                              //       r"$" + "${data.orderReceipt![0].total}",
                              // ),
                              // Divider(
                              //   color: whiteAccentColor,
                              // ),
                              // TextInRow(
                              //   firstText: appLoc.servicePrice,
                              //   secondText: r'$0.00',
                              // ),
                              // Divider(
                              //   color: whiteAccentColor,
                              // ),
                              TextInRow(
                                secondTextweight: FontWeight.w700,
                                firstText: "Total amount to pay",
                                secondText:
                                    r"$CA " + data.orderReceipt![0].total,
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          text: AutoSizeText(
                            "Continue to Pay",
                            // appLoc.login.toUpperCase(),
                            style: TextStyle(
                                fontFamily: 'poPPinSemiBold',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 18.0),
                            minFontSize: 8.0,
                          ),
                          event: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    distance: data.orderReceipt![0].distance
                                        .toString(),
                                    vehicleCategory: data
                                        .orderReceipt![0].vehicleCategory.id
                                        .toString(),
                                    name: data.orderReceipt![0].userName,
                                    img: data.orderReceipt![0].image,
                                    carModal: data.orderReceipt![0].carModel,
                                    carNo: data.orderReceipt![0].plateNumber,
                                    totalPrice: data.orderReceipt![0].total,
                                    paymentMode:
                                        data.orderReceipt![0].paymentMethod,
                                    driverId: data.orderReceipt![0].driverId,
                                    orderId: data.orderReceipt![0].id,
                                    extraDistance:
                                        data.orderReceipt![0].extraDistance,
                                    extraDistancePrice: data
                                        .orderReceipt![0].extraDistancePrice,
                                    // extraMinPrice:
                                    //     data.orderReceipt![0].extraKmPrice,
                                    // extraTime: data.orderReceipt![0].extraTime,
                                    grandTotal:
                                        data.orderReceipt![0].grandTotal,
                                  ),
                                ));
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => FeedBackScreen(
                            //       name: data.orderReceipt![0].userName,
                            //       img: data.orderReceipt![0].image,
                            //       carModal: data.orderReceipt![0].carModel,
                            //       carNo: data.orderReceipt![0].plateNumber,
                            //     ),
                            //   ),
                            // );
                          },
                          buttonHeight: 50,
                          // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                          isRounded: true,
                          bgColor: black080809Color,
                        ),

                        // FutureBuilder<PaymentConfiguration>(
                        //     future: _googlePayConfigFuture,
                        //     builder: (context, snapshot) => snapshot.hasData
                        //         ? (Platform.isAndroid)
                        //             ? data.orderReceipt![0].paymentMethod != 1
                        //                 ? GooglePayButton(
                        //                     paymentConfiguration:
                        //                         snapshot.data!,
                        //                     paymentItems: _paymentItems,
                        //                     type: GooglePayButtonType.buy,
                        //                     margin: const EdgeInsets.only(
                        //                         top: 15.0),
                        //                     onPaymentResult: (result) async {
                        //                       log("result is: $result");

                        //                       log(snapshot.data.toString());

                        //                       String token =
                        //                           result['paymentMethodData']
                        //                                   ['tokenizationData']
                        //                               ['token'];
                        //                       log("token is-->>>$token");

                        //                       final tokenJson = Map.castFrom(
                        //                           json.decode(token));

                        //                       log("token json is ${tokenJson['id']}");

                        //                       var cardToken = tokenJson['id'];

                        //                       var body = {
                        //                         'token': cardToken,
                        //                         'order_id':
                        //                             data.orderReceipt![0].id,
                        //                         "driver_id": data
                        //                             .orderReceipt![0].driverId,
                        //                         "amount":
                        //                             data.orderReceipt![0].total
                        //                       };

                        //                       log(body.toString());

                        //                       var response = await dio.post(
                        //                         'https://php.parastechnologies.in/taxi/public/api/webservice/driver/payment',
                        //                         data: body,
                        //                         options: Options(headers: {
                        //                           "Authorization":
                        //                               "Bearer $sessionToken"
                        //                         }),
                        //                       );

                        //                       if (response.data["success"] ==
                        //                           1) {
                        //                         showDialog(
                        //                           context: context,
                        //                           builder: (ctx) => AlertDialog(
                        //                             title: const Text(
                        //                                 "Ride Payment"),
                        //                             content: const Text(
                        //                                 "Payment successfull"),
                        //                           ),
                        //                         );
                        //                       } else {
                        //                         showDialog(
                        //                           context: context,
                        //                           builder: (ctx) => AlertDialog(
                        //                             title: const Text(
                        //                                 "Payment unsuccessfull"),
                        //                             content: Text(response
                        //                                 .data["message"]),
                        //                           ),
                        //                         );
                        //                       }
                        //                     },
                        //                     loadingIndicator: const Center(
                        //                       child:
                        //                           CircularProgressIndicator(),
                        //                     ),
                        //                   )
                        //                 : SizedBox()
                        //             : SizedBox()
                        //         : const SizedBox.shrink()),
                        // // Example pay button configured using a string
                        // (Platform.isIOS)
                        //     ? data.orderReceipt![0].paymentMethod != 1
                        //         ? ApplePayButton(
                        //             // paymentConfigurationAsset: 'assets/icons/car.png',
                        //             paymentConfiguration:
                        //                 PaymentConfiguration.fromJsonString(
                        //                     payment_configurations
                        //                         .defaultApplePay),
                        //             paymentItems: _paymentItems,

                        //             style: ApplePayButtonStyle.black,
                        //             type: ApplePayButtonType.buy,
                        //             margin: const EdgeInsets.only(top: 15.0),
                        //             onPaymentResult: onApplePayResult,
                        //             loadingIndicator: const Center(
                        //               child: CircularProgressIndicator(),
                        //             ),
                        //           )
                        //         : SizedBox()
                        //     : SizedBox(),

                        // SizedBox(
                        //   height: 0,
                        // )
                      ],
                    ),
                  ),
                );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// class ReceiptScreen extends StatelessWidget {
//   const ReceiptScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     late final Future<PaymentConfiguration> _googlePayConfigFuture;

//   var _paymentItems = [
//     PaymentItem(
//       label: 'Total',
//       amount: '99.99',
//       status: PaymentItemStatus.final_price,
//     )
//   ];
//     double? height = MediaQuery.of(context).size.height;
//     double? width = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: whiteColor,
//         appBar: AppBar(
//           elevation: 0.3,
//           backgroundColor: whiteColor,
//           centerTitle: true,
//           title: CommonText(
//             text: appLoc.receipt,
//             fontWeight: FontWeight.w600,
//             fontColor: blackColor,
//             fontFamily: "poPPinMedium",
//             fontSize: 18,
//           ),
//         ),
//         body: StreamBuilder<GetReceiptState>(
//           stream: context.read<OrderProvider>().orderReceiptApi(),
//           builder: (context, state) {
//             log("order state: $state");
//             switch (state.data.runtimeType) {
//               case GetReceiptLoading:
//                 log("---->>>Receipt Loading called   <<<<-------");

//                 return const Center(child: CircularProgressIndicator());

//               case GetReceiptFailure:
//                 final failure = (state.data as GetReceiptFailure).failure;

//                 showToast(message: failure.toString());

//                 log("failure is:  $failure");
//                 dismissLoading();

//                 // showToast(message: failure);
//                 return const SizedBox.shrink();

//               case GetReceiptLoaded:
//                 final data = (state.data as GetReceiptLoaded).data;
//                 log("---->>>Receipt loaded called   <<<<-------");

//                 log("data is $data");

//                 dismissLoading();

//                 DateTime dt1 = DateTime.parse(data.orderReceipt![0].startTime);
//                 DateTime dt2 = data.orderReceipt![0].endTime;
//                 Duration timeTaken = dt2.difference(dt1);

//                 log(timeTaken.toString());
//                 log(timeTaken.inHours.toString());
//                 log(timeTaken.inMinutes.toString());
//                 log(timeTaken.inSeconds.toString());

//                 return Container(
//                   height: height,
//                   width: width,
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 20, left: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 CommonCircularImageContainer(
//                                   height: 45,
//                                   width: 45,
//                                   image: data.orderReceipt![0].image,
//                                 ),
//                                 SizedBox(
//                                   width: 11,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     CommonText(
//                                       text: data.orderReceipt![0].userName,
//                                       fontWeight: FontWeight.w500,
//                                       fontColor: blackColor,
//                                       fontFamily: "poPPinMedium",
//                                       fontSize: 16,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Image.asset(starImage),
//                                         CommonText(
//                                           text: data.orderReceipt![0].rating
//                                               .toString(),
//                                           fontWeight: FontWeight.w600,
//                                           fontColor: blackColor,
//                                           fontFamily: "poPPinMedium",
//                                           fontSize: 14,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 CommonText(
//                                   text: data.orderReceipt![0].carModel,
//                                   fontWeight: FontWeight.w400,
//                                   fontColor: grey585858Color,
//                                   fontFamily: "poPPinMedium",
//                                   fontSize: 12,
//                                 ),
//                                 CommonText(
//                                   text: data.orderReceipt![0].plateNumber,
//                                   fontWeight: FontWeight.w500,
//                                   fontColor: blackColor,
//                                   fontFamily: "poPPinMedium",
//                                   fontSize: 12,
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         CommonText(
//                           text: appLoc.fareBreakdown,
//                           fontWeight: FontWeight.w600,
//                           fontColor: blackColor,
//                           fontFamily: "poPPinMedium",
//                           fontSize: 16,
//                         ),
//                         TextInRow(
//                           firstText: appLoc.date,
//                           secondText: DateFormat('dd MMM yyyy')
//                               .format(data.orderReceipt![0].orderTime)
//                               .toString(),
//                         ),
//                         TextInRow(
//                           firstText: appLoc.time,
//                           secondText: DateFormat('h:mma')
//                               .format(data.orderReceipt![0].orderTime)
//                               .toString(),
//                         ),
//                         TextInRow(
//                           firstText: appLoc.totalDistance,
//                           secondText: data.orderReceipt![0].distance + "Km",
//                         ),
//                         TextInRow(
//                           firstText: appLoc.timeTaken,
//                           secondText: '30 min',
//                         ),
//                         CommonText(
//                           text: appLoc.paymentInformation,
//                           fontWeight: FontWeight.w600,
//                           fontColor: blackColor,
//                           fontFamily: "poPPinMedium",
//                           fontSize: 16,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CommonText(
//                               text: appLoc.paymentInformation,
//                               fontWeight: FontWeight.w500,
//                               fontColor: grey7D7979Color,
//                               fontFamily: "poPPinMedium",
//                               fontSize: 13,
//                             ),
//                             Row(
//                               children: [
//                                 data.orderReceipt![0].paymentMethod == 1
//                                     ? SvgPicture.asset(
//                                         cashIconSvg,
//                                         height: 30,
//                                         width: 30,
//                                         fit: BoxFit.fill,
//                                       )
//                                     : SvgPicture.asset(
//                                         googleIconSvg,
//                                         height: 30,
//                                         width: 30,
//                                         fit: BoxFit.fill,
//                                       ),
//                                 SizedBox(
//                                   width: 10.0,
//                                 ),
//                                 CommonText(
//                                   text: data.orderReceipt![0].paymentMethod == 1
//                                       ? appLoc.cash
//                                       : appLoc.googlePay,
//                                   fontWeight: FontWeight.w400,
//                                   fontColor: grey7D7979Color,
//                                   fontFamily: "poPPinMedium",
//                                   fontSize: 16,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: greyB2B2B2Color.withOpacity(0.13),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: EdgeInsets.only(
//                               top: 13, bottom: 13, left: 11, right: 11),
//                           child: Column(
//                             children: [
//                               TextInRow(
//                                 firstText: appLoc.price,
//                                 secondText:
//                                     r"$" + "${data.orderReceipt![0].total}",
//                               ),
//                               Divider(
//                                 color: whiteAccentColor,
//                               ),
//                               TextInRow(
//                                 firstText: appLoc.servicePrice,
//                                 secondText: r'$0.00',
//                               ),
//                               Divider(
//                                 color: whiteAccentColor,
//                               ),
//                               TextInRow(
//                                 secondTextweight: FontWeight.w700,
//                                 firstText: appLoc.totalPrice,
//                                 secondText:
//                                     r"$" + "${data.orderReceipt![0].total}",
//                               ),
//                             ],
//                           ),
//                         ),
//                         CustomButton(
//                           text: Text(
//                             "Continue",
//                             // appLoc.login.toUpperCase(),
//                             style: TextStyle(
//                               fontFamily: 'poPPinSemiBold',
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                           event: () async {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => FeedBackScreen(
//                                   name: data.orderReceipt![0].userName ?? "",
//                                   img: data.orderReceipt![0].image ?? "",
//                                   carModal:
//                                       data.orderReceipt![0].carModel ?? "",
//                                   carNo:
//                                       data.orderReceipt![0].plateNumber ?? '',
//                                 ),
//                               ),
//                             );
//                           },
//                           buttonHeight: 50,
//                           // buttonHeight: MediaQuery.of(context).size.height * 0.080,
//                           isRounded: true,
//                           bgColor: black080809Color,
//                         ),
//                                 FutureBuilder<PaymentConfiguration>(
//               future: _googlePayConfigFuture,
//               builder: (context, snapshot) => snapshot.hasData
//                   ? GooglePayButton(
//                       paymentConfiguration: snapshot.data!,
//                       paymentItems: _paymentItems,
//                       type: GooglePayButtonType.buy,
//                       margin: const EdgeInsets.only(top: 15.0),
//                       onPaymentResult: (result) {
//                         log("result is: $result");

//                         log(snapshot.data.toString());

//                         // Map<String, dynamic> tokenizationDataMap =
//                         //     Map<String, dynamic>.from(
//                         //         result['tokenizationData']);
//                         // String token = tokenizationDataMap['token'];

//                         String token = result['paymentMethodData']
//                             ['tokenizationData']['token'];
//                         log("token is-->>>$token");
//                       },
//                       loadingIndicator: const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     )
//                   : const SizedBox.shrink()),
//           // Example pay button configured using a string

//           ApplePayButton(
//             // paymentConfigurationAsset: 'assets/icons/car.png',
//             paymentConfiguration: PaymentConfiguration.fromJsonString(
//                 payment_configurations.defaultApplePay),
//             paymentItems: _paymentItems,

//             style: ApplePayButtonStyle.black,
//             type: ApplePayButtonType.buy,
//             margin: const EdgeInsets.only(top: 15.0),
//             onPaymentResult: onApplePayResult,
//             loadingIndicator: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),

                       
                       
//                         SizedBox(
//                           height: 0,
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
  
  
  
//   }
// }
