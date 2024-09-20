import 'package:GetsbyRideshare/core/presentation/widgets/cache_network_widget.dart';
import 'package:GetsbyRideshare/core/static/colors.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:GetsbyRideshare/socket/test_socket_provider.dart';
import 'package:GetsbyRideshare/features/order/presentation/pages/components/payment_screen.dart';
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

import 'package:pay/pay.dart';

import '../../../../core/utility/duration_helper.dart';
import '../../../../core/utility/dynamic_toasstring_helper.dart';
import '../../../testing/widgets/text_in_row.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({Key? key}) : super(key: key);
  static const routeName = '/receipt';

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

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App without payment?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.of(context).size.height;
    double? width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
          body: Consumer<TestSocketProvider>(
            builder: (context, socketProvider, child) {
              final provider = context.read<TestSocketProvider>();
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
                              CustomCacheNetworkImage(
                                  img: provider.receiptResponseModel!.data!.image ?? "",
                                  size: 45),
                              SizedBox(
                                width: 11,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /**name */
                                  CommonText(
                                    text: provider
                                            .receiptResponseModel!.data!.name ??
                                        '',
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
                                        text: provider.receiptResponseModel
                                                    ?.data?.driverRating !=
                                                null
                                            ? " " +
                                                "${double.parse(provider.receiptResponseModel!.data!.driverRating.toString()).toStringAsFixed(1)}"
                                            : "0.0",
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CommonText(
                                text: provider.receiptResponseModel!.data!.carModel,
                                fontWeight: FontWeight.w400,
                                fontColor: grey585858Color,
                                fontFamily: "poPPinMedium",
                                fontSize: 12,
                              ),
                              //plate number
                              CommonText(
                                text: provider.receiptResponseModel!.data!.plateNumber,
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
                        secondText: DateFormat.yMMMd().format(
                            (DateFormat("yyyy-MM-dd HH:mm:ss").parse(provider.receiptResponseModel!.data!.createdAt.toString(), true)).toLocal()),

                        // DateFormat('dd MMM yyyy')
                        //     .format(provider.receiptResponseModel!.orderTime)
                        //     .toString(),
                      ),
                      TextInRow(
                        firstText: appLoc.time,
                        secondText: DateFormat.jm().format(
                            (DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                                    provider.receiptResponseModel!.data!.createdAt.toString(), true))
                                .toLocal()),
                      ),
                      TextInRow(
                        firstText: appLoc.totalDistance,
                        secondText: "${provider.receiptResponseModel!.data!.actual_distance ?? double.parse(provider.receiptResponseModel!.data!.distance1 ?? "0.0").toStringAsFixed(2)} Km",
                      ),
                      TextInRow(
                        firstText: "Time Taken",
                        secondText:provider.receiptResponseModel!.data!.actual_time!= null? formatDuration(num.parse(provider.receiptResponseModel!.data!.actual_time.toString()).toInt()):"0.0",
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
                              provider.receiptResponseModel!.data!.paymentMethod
                                          .toString() ==
                                      "1"
                                  ? SvgPicture.asset(
                                      cashIconSvg,
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.fill,
                                    )
                                  : provider.receiptResponseModel!.data!
                                              .paymentMethod
                                              .toString() ==
                                          "2"
                                      ? SvgPicture.asset(
                                          creditIcon,
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.fill,
                                        )
                                      : provider.receiptResponseModel!.data!
                                                  .paymentMethod
                                                  .toString() ==
                                              "3"
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
                                text: provider.receiptResponseModel!.data!
                                            .paymentMethod
                                            .toString() ==
                                        "1"
                                    ? appLoc.cash
                                    : provider.receiptResponseModel!.data!
                                                .paymentMethod
                                                .toString() ==
                                            "2"
                                        ? "Credit Card"
                                        : provider.receiptResponseModel!.data!
                                                    .paymentMethod
                                                    .toString() ==
                                                "3"
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
                            TextInRow(
                                secondTextweight: FontWeight.w700,
                                firstText: "Total amount to pay ",
                                secondText: r"CA$ " +
                                    convertToFixedTwoDecimal(provider
                                        .receiptResponseModel!.data!.newTotal)),
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
                          print(provider.receiptResponseModel!.data!
                              .toJson()
                              .toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                  actualDistancePrice: provider
                                      .receiptResponseModel!
                                      .data!
                                      .actual_distance_price,
                                  distanceTravelled: provider
                                          .receiptResponseModel!
                                          .data!
                                          .actual_distance ??
                                      provider.receiptResponseModel!.data!
                                          .distance1 ??
                                      "0.0",
                                  pricePerKm: provider
                                      .receiptResponseModel!.data!.price_km,
                                  pricePerMin: provider
                                      .receiptResponseModel!.data!.price_min,
                                  extraTime: provider.receiptResponseModel!
                                          .data!.extraTime ??
                                      "",
                                  extraTimePrice: provider.receiptResponseModel!
                                      .data!.extraTimePrice
                                      .toString(),
                                  newTotal: provider
                                      .receiptResponseModel!.data!.newTotal
                                      .toString(),
                                  pendingAmount: provider
                                      .receiptResponseModel!.data!.pendingAmount
                                      .toString(),
                                  distance: provider
                                      .receiptResponseModel!.data!.distance
                                      .toString(),
                                  vehicleCategory: 1.toString(),
                                  name: provider
                                      .driverDetailResponseModel!.message.name,
                                  img: provider
                                          .receiptResponseModel!.data!.image ??
                                      "",
                                  carModal: provider.driverDetailResponseModel!
                                      .message.carModel,
                                  carNo: provider.driverDetailResponseModel!
                                      .message.plateNumber,
                                  totalPrice: provider
                                      .receiptResponseModel!.data!.total,
                                  paymentMode: int.parse(provider
                                      .receiptResponseModel!.data!.paymentMethod
                                      .toString()),
                                  driverId: provider
                                      .driverDetailResponseModel!.message.id
                                      .toString(),
                                  orderId: provider
                                      .receiptResponseModel!.data!.id
                                      .toString(),
                                  extraDistance: provider.receiptResponseModel!
                                      .data!.extraDistance,
                                  extraDistancePrice: provider
                                      .receiptResponseModel!
                                      .data!
                                      .extraDistancePrice,
                                  timeTaken: provider.receiptResponseModel!.data!.actual_time.toString() == "0.0" ? "0"
                                      : provider.receiptResponseModel!.data!.actual_time,
                                  baseFare: provider
                                      .receiptResponseModel!.data!.baseFare,
                                  techFee: provider
                                      .receiptResponseModel!.data!.techFee,
                                  minimumFare: provider
                                      .receiptResponseModel!.data!.minimumFare,
                                  // extraMinPrice:
                                  //     provider.receiptResponseModel!.extraKmPrice,
                                  // extraTime: provider.receiptResponseModel!.extraTime,
                                  // grandTotal:
                                  //     provider.receiptResponseModel!.data.total,
                                ),
                              ));
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => FeedBackScreen(
                          //       name: provider.receiptResponseModel!.userName,
                          //       img: provider.receiptResponseModel!.image,
                          //       carModal: provider.receiptResponseModel!.carModel,
                          //       carNo: provider.receiptResponseModel!.plateNumber,
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
                      //             ? provider.receiptResponseModel!.paymentMethod != 1
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
                      //                             provider.receiptResponseModel!.id,
                      //                         "driver_id": data
                      //                             .orderReceipt![0].driverId,
                      //                         "amount":
                      //                             provider.receiptResponseModel!.total
                      //                       };

                      //                       log(body.toString());

                      //                       var response = await dio.post(
                      //                         'https://api.gatsbyrideshare.com/api/webservice/driver/payment',
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
                      //     ? provider.receiptResponseModel!.paymentMethod != 1
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
            },
          )

          ),
    );
    // );
  }
}
